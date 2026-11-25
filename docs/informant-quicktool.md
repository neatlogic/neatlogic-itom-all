# Informant 全景图快捷工具

## 功能与边界

全景图的主机节点使用通用工具列表，服务实例按采集到的 `product` 匹配组合工具。关联不依赖 CMDB，不按 OS 分类。聚合节点每次选择一个服务实例，确认执行目标、激活版本及参数后执行；正常和异常对象均可使用。

配置、执行和审计查看分别授权。快捷执行还须通过 AutoExec 基础权限和组合工具执行权限；查看记录沿用 AutoExec 作业查看边界。AutoExec 原有入口的授权规则保持不变。

左侧配置和审计菜单仅按独立权限显示，不根据 AutoExec 加载状态隐藏。进入页面后检查 AutoExec 是否已加载、未失效且可选 Crossover 契约存在；不可用或能力查询失败时显示原因并阻止配置、查询和执行。后端每次提交重新判断。缺少 AutoExec 不妨碍 Informant 启动和全景图使用。

## 执行与追溯

### 作业配置 v2

快捷工具配置参考流程自动化节点的单次作业详情，保留入口元数据，增加作业名称、名称前缀、场景及执行参数配置。一个入口对应一个组合工具和一个作业，策略固定为“单次创建作业”，不提供流程表单、表达式、输出回填或批量策略。

运行参数与执行参数分别按固定值、当前对象字段、执行时填写配置。前端复用 AutoExec 的参数值组件注册表，后端复用 `ScriptParamTypeFactory` 转换器，覆盖当前注册的 20 种参数类型。文件对象、节点列表、多选集合、JSON 和布尔值按原生类型传递；转换和创建不提前调用执行时加密或文件 ID 出参转换。普通默认值在未提交对应输入字段时保留，显式 null 表示清空；敏感参数只读取本次输入，不使用组合工具的敏感默认值。

工具已经固定的执行字段只读；已引用作业参数的执行字段只展示引用关系，由该作业参数驱动，不能另设执行映射覆盖。尚未指定的执行用户、协议、并发及 Runner 参数允许配置来源，最终连接协议仍限定 Tagent。协议候选由 AutoExec 服务端查询并返回，不要求用户额外具备 CMDB 页面权限。

当前主机节点字段由 Informant 服务端构造。引用为执行目标的作业参数可选择当前节点、固定节点或执行时多选，缺少目标映射的旧配置沿用当前主机。多个引用合并去重。普通节点参数仅作入参。服务端口不成为连接端口。阶段或分组覆盖目标、前置输出决定目标等无法在确认时确定目标的配置不予准入。敏感参数不能用于名称前缀，也不能被执行用户、Runner 组或标签等可见字段间接引用。

配置继续使用原 `config_json`，格式版本为 `schemaVersion: 2`，读取旧配置时补齐默认字段并保留原映射，不自动修改存量记录。重新保存才写入 v2；失效的历史映射保留并提示重新配置，不静默清空。Informant 在模块内解析映射，分别构造脱敏预览、已确认目标和原生 `AutoexecJobVo`。AutoExec 按其资源授权和逐台路由校验创建、启动作业。`preview` 支持 `param`、`executeParam`、`scenario` 和 `complete`；草稿预览允许缺少运行输入；点击“执行”时先进行全部控件校验和服务端完整解析，通过后直接提交。若配置、版本或目标变化则停止本次提交，展示更新后的信息并要求用户再次点击执行；输入变化立即使进行中的旧预检失效。提交成功后关闭输入窗口，在独立结果窗口以普通文字显示“作业已生成”，后接可点击的实际作业名称，最终运行状态由作业详情呈现。

执行确认窗口只接收节点菜单选定的快捷工具，不提供工具列表或重新选择入口；失效后关闭窗口从节点菜单重新选择。基本信息使用左侧标签、右侧内容的响应式两列，窄窗口自动单列。固定的执行前提示已移除；配置、版本或目标实际发生变化时仍显示对应提示。执行配置和目标参数使用左右标签内容并保留双列，作业参数保持原类型编辑器布局。参数区只呈现需要填写的执行配置，对应字段和关联作业参数已在下方输入时不再在摘要重复。默认值回填到原生表单，仅首次初始化；后续预览保留人工修改和显式清空。来源节点、实际执行目标和固定配置由摘要展示；节点、文件和结构化参数保留完整宽度。

专用解析结果增加 `versionText`、`runnerGroupName`、`runnerGroupTagNameList`、`parallelPolicyText` 展示字段，Informant 通过严格白名单透传。版本显示实际版本号 `vN`，执行器组和标签显示真实名称，随机分配使用本地化文案；原执行 ID 和枚举值仍供后端处理，前端不以内部编号兜底。服务名称直接读取服务端采集上下文的 `context.name`，数量仅展示当前并发策略对应项。

Informant 通过 AutoExec 原生 crossover 检查能力，支持多目标的版本返回 3。此次升级须配套发布 Informant、Informant Base、AutoExec 和 AutoExec Base。沿用现有前端、HTTP 接口、配置和数据库结构。

从主机 A 发起时，Informant 记录 A 的来源身份。若参数选中 B、C，确认摘要及作业快照使用 B、C。AutoExec 在完整预览、创建和启动时复核目标，任一目标不可执行时返回失败。

阶段配置 `{}` 或 `isPresetExecuteConfig=0` 按原自动化引擎语义继承全局目标，不能因存在配置对象而误判为目标覆盖；预设开关启用的阶段覆盖仍拒绝。灰度组按其实际生效字段判断，不能套用阶段开关。专用批量查询通过框架 `CompressHandler` 读取普通 JSON 和 `GZIP:` 配置，不改原自动化列表、Mapper 或执行服务方法。

敏感参数只允许执行时填写，禁止将其作为固定值或上下文字段存入普通配置。预览清理敏感参数默认值，确认上下文摘要用于检测采集地址、服务端口等字段变化；执行接口审计只保留脱敏定位信息。

执行先在同一事务创建未启动作业和 Informant 关联，事务提交成功后才启动。关联写入失败不得执行。重复提交及启动重试使用原作业，不能创建第二个作业。

执行审计以 AutoExec 作业、参数和日志为准，Informant 只记录对象、配置、提交标识、作业 ID 和创建时间。主机使用 `informantUuid`，服务使用 `informantUuid + objId`；画布 ID 和 CMDB ID 不参与执行身份定位。 记录页主机列展示当前采集主机的“主机名 / IP”，不显示内部 UUID；名称或地址缺失时显示现有的一项，主机已删除时显示 `-`，历史记录继续保留。

## 日志清理

AutoExec 自行清理作业，不查询或删除 Informant 关联。Informant 通过独立审计清理项按关联创建时间清理，不调用 AutoExec；无有效保留期时不自动清理。无外键、级联删除或删除回调。

关联查询先过滤已经删除或无权查看的作业，再计算总数和分页。两边保留期限不同是允许的：过期作业对应的关联暂留库中但不再展示，直至 Informant 自身清理。

## 上线和验证

数据库升级脚本由正常模块升级流程应用。实施期间不直接修改现有租户数据库，不删除历史配置、作业和关联记录。

上线后先分配独立权限，配置 Tagent 组合工具，并使用无副作用的诊断工具验证目标、参数、作业详情及关联查询。真实执行会创建作业和连接目标，应在所选测试环境具备升级后的表结构与服务后验证。

静态编译、隔离测试、浏览器验证、已部署环境真实执行与人工验收分别记录，不相互替代。

### 入口和授权

- 配置入口：左侧“自动化 → 组合工具配置”，路由 `quicktool-config`；全景图顶部不再提供配置入口。
- 审计入口：左侧“自动化 → 组合工具审计”，路由 `quicktool-record`；全景图顶部不再提供集中审计入口。
- 执行入口：全景图中主机、服务图标旁显示轻量的快捷工具提示图标，仅在模块可用、有执行权限且匹配启用配置时显示。点击提示图标通过 G6 官方 Contextmenu 在节点旁展开工具菜单；聚合服务存在多个匹配实例时先在菜单中选择一个实例，再选择工具并打开预览确认。点击业务图标本身仍打开原详情，系统、模块不显示执行提示。工具图标不提供悬停提示，避免与菜单相互遮挡；原有异常信息提示保留。
- 节点提示通过 `informant/quicktool/entry/list` 一次读取主机启用标记和服务产品集合，不逐节点查询工具详情或校验凭据。提示只表示存在匹配的启用配置；工具列表、预览和提交仍由后端分别检查实际对象、权限、版本、目标及参数。主机目标使用真实 UUID，服务目标使用真实 UUID 和 objId，不使用画布节点编号。
- 两个路由使用标准 `ismenu: true` 和 `informantquicktool` 菜单分组，分别按配置、审计权限显示；独立执行权限不展开配置或审计菜单。
- 页面内部处理模块不可用和能力请求失败的提示；不新增动态菜单组件，也不修改公共布局、公共侧栏或基础框架前端代码。
- 权限：`INFORMANT_QUICKTOOL_CONFIG`、`INFORMANT_QUICKTOOL_EXECUTE`、`INFORMANT_QUICKTOOL_AUDIT`，分别授权；不通过普通修改权限展开。
- API 前缀：`informant/quicktool`。包括 `capability`、`config/search|get|save|delete`、`product/list`、`tool/list|get`、`available/list`、`preview`、`execute`、`record/search`、`record/config/list`。
- `tool/list` 只提供工具及激活版本摘要，运行参数通过选中后的 `tool/get` 加载。列表参照 `autoexec/combop/list` 使用 SQL 权限筛选和批量读取；复杂快捷执行结构按批次校验后累计真实总数，不以当前页过滤结果冒充全量分页总数。协议元数据在每个请求内只加载一次，不引入跨请求权限缓存。
- 关联日志保留期：执行审计页的现有审计配置组件，清理项 `INFORMANT-QUICKTOOL-RECORD`；配置入口沿用系统管理员授权。

### 本次验证记录（2026-11-16）

- Reactor 编译通过；后端 69 项测试通过，包括自动化快捷执行 17 项、Informant 快捷调用 15 项、现有 CI 持久化 32 项及全景图 5 项。
- 前端快捷调用、全景图及服务管理 59 项测试通过，包含实际 Vue 渲染的重试入口测试；定向 ESLint、模板编译及差异空白检查通过。
- 标准菜单方案通过 11 项菜单及快捷工具测试，覆盖独立权限、缺少 AutoExec 时仍展示菜单，以及进入配置/审计页面后展示不可用原因且不查询业务数据。入口文件 ESLint 通过；公共布局和侧栏相对 HEAD 均无改动。
- 列表性能修正通过 37 项定向测试（原自动化 17 项、真实 MyBatis/H2 列表 5 项、Informant 15 项）。501 候选场景实际断言 1 次候选计数、3 次每批 200 条的联合读取及 1 次协议元数据加载，不调用逐工具详情或运行参数序列化。准确总数仍需逐批解析候选配置，不引入跨请求缓存；未实测部署后接口响应时间。
- 2026-11-17 修正真实配置兼容性：40 项定向测试通过（自动化安全 19 项、列表 SQL 6 项、Informant 15 项），新增编辑器继承占位配置及压缩配置回归。只读连接配置文件指向的真实远程 develop 租户进行排查，不使用 localhost 同名库数据作为运行库证据，不修改远程数据或服务。
- 同次排查用真实远程 develop 的专用 Mapper 和列表服务完成只读验证：管理员范围返回 17 个工具；解压后配置快照的纯结构校验旧规则为 0、新规则为 23，再经实际 Tagent 协议过滤为 17。只读验证未创建作业、未调用 Runner，页面结果仍须后端更新后确认。
- 使用框架 Java 语言资源校验器单独验证 Informant 中英文资源通过。
- 2026-11-17 全景图入口调整：移除顶部配置和集中审计入口，接通实际主机详情底部的快捷执行。41 项前端定向测试及三处 Vue 文件 ESLint 通过，覆盖真实模板渲染、权限和能力开关、点击后传递采集主机 UUID；未进行浏览器验证或真实工具执行。
- 2026-11-17 后续交互调整取代上述详情执行入口：工具提示改在节点右下侧，右上异常标记保持原样；移除主机详情底部及服务行中的旧执行入口。新 `entry/list` 接口仅返回启用配置的匹配条件；新增实例选择页，先展示工具列表、选择后再预览。
- 此次后端 Reactor 编译与 18 项 Informant 快捷工具测试通过；前端模块 315 项测试、定向 ESLint 和差异空白检查通过。独立 Chrome 使用实际页面方法和 G6 完成明暗主题截图、正常/异常主机与服务工具标记真实点击、正文点击保持详情、工具悬停提示和能力失效清除标记验证。此为隔离渲染验证，不代表已部署页面或真实执行验收；未启动作业，未改数据库或重启服务。新增接口需与前端同步更新。
- 2026-11-17 菜单交互继续调整：节点提示改为无底色的省略号，点击在原位展开标准 Dropdown，选择工具后才打开执行确认。多实例通过同一菜单选择和返回；菜单转移至 body，自动避让窗口边缘，外点、Esc 和画布移动关闭菜单，已打开的执行确认不受画布移动影响。49 项定向测试、ESLint 和差异空白检查通过；独立 Chrome 使用真实 G6、Vue 和 Dropdown 验证菜单渲染、边缘避让、Esc、菜单选择传递真实目标及选定工具。仅修改 Informant 前端，无新增后端接口或真实执行。
- 2026-11-17 修复菜单重复点击：旧 Dropdown 的 document clickoutside 在 G6 重开菜单后关闭了新的组件状态。改为模块内继承 G6 官方 Contextmenu，以官方节点点击事件触发，仅适配窗口定位、异步响应隔离、公共主题及外部关闭；删除虚拟锚点 picker。去掉工具图标 tooltip，保留异常提示。317 项模块测试、定向 ESLint 和差异空白检查通过；独立 Chrome 真实 G6 验证连续点击同节点、切换节点、4 轮外点关闭重开、Esc 和工具选择真实 UUID。未调用真实预览或执行作业。
- 2026-11-17 收窄菜单：公共下拉样式的 `width: inherit` 使 body 下的菜单继承整页宽度，菜单容器现显式使用内容宽度，最小 120px、最大 280px，并受视口限制。3 项事件测试、ESLint 和差异检查通过；独立 Chrome 带真实公共组件 CSS 和 `body { width: 100% }` 验证明暗主题短名称宽 120px、长名称宽 280px 且无横向溢出，重复打开和选择仍正常。
- 2026-11-17 手动“适应画布”由 `fitView({ when: 'overflow' })` 改为 `when: 'always', direction: 'both'`，解决图已缩小时只居中的问题。初始适应、自动刷新与布局不变。49 项相关测试、ESLint 和差异检查通过；真实 G6 浏览器中，修正前 0.08 缩放保持不变，修正后从 0.08 和 1.5 均适配到约 0.957，图形位于留白范围内，节点原始坐标不变。
- 2026-11-17 修复服务节点有入口但工具列表为空：`getInformantServiceByUuidAndObjId` 原只读取标识、名称和配置项关联，快捷调用上下文中的产品为空，无法匹配服务配置。查询补齐 `product/protocol/port`，确保工具匹配及参数映射均来自服务端采集记录。真实 MyBatis/H2 用例修复前重现列表为空，修复后验证 Tomcat 匹配、Redis 不匹配、协议端口映射及忽略客户端伪造字段。Reactor 编译、42 项快捷工具及服务关联测试、差异检查通过；未访问或修改真实库、未执行作业。需更新后端后再验收实际页面。
- 2026-11-17 修复预览 `unique Tagent account`：专用快捷执行预检原将 Tagent 认证账户名称与 OS 执行用户比较，现保留账户唯一性但不要求名称相同。Tagent 记录中的历史 Runner ID 也不再被当作 RunnerMap ID；路由复用原作业源契约，按阶段模式、目标 IP、规则及标签只读查询候选。真实远程 develop 只读检查确认当前工具执行用户为 root，Tagent 账户名称为按 IP/端口生成的名称，MySQL Tagent Runner ID 为空；这些不能作为无有效自动化路由的依据。新增回归先复现旧误判，修复后 31 项 AutoExec 专用测试及 Reactor 编译通过，覆盖主副 IP、账户及目标歧义、候选缺失、合法 Runner 池及执行用户保留，并使用真实路由处理器验证只调用读取方法；差异检查通过。未改原 AutoExec 执行方法、租户数据或服务状态，未创建真实作业，需更新 AutoExec 后端后验收实际预览。
- 2026-11-17 作业配置 v2：联合 Reactor 编译和 102 项后端测试通过（AutoExec 52、Informant 50），Informant 前端 318 项测试、定向 ESLint 和差异检查通过。类型矩阵覆盖全部 20 种真实处理器与转换重入、默认值及显式清空、敏感默认值禁用、派生执行字段和单节点锁定。独立双模块联调使用真实保存/解析/READY 构造和 H2 关联事务，验证提交后才调用启动替身，关联失败回滚；未调用真实 Runner。实际 Vue、TsForm、TsTable 和 AutoExec 原生类型控件的隔离 Rspack 构建通过，Chrome 明暗主题检查配置与确认页面无运行错误；AutoExec 与 Informant 中英文 Java 资源校验通过。全工作区既有 i18n owner 错误仍通过 `-Dexec.skip=true` 排除，未改无关模块。未部署、修改业务数据库或执行真实作业，部署后的无副作用诊断验收仍待进行。
- 全工作区测试生命周期原有 i18n 检查被 `neatlogic-suzhoubank` 的 owner `szbank` 与目录名不一致阻断；定向测试使用 `-Dexec.skip=true` 绕过该无关构建插件，不更改其源文件。
- 未修改真实租户数据库、未启动真实作业、未重启现有服务；浏览器连接超时，未取得登录后页面或明暗主题截图证据，仍需部署后的无副作用诊断联调及人工验收。

- 2026-11-17 执行确认页紧凑布局：移除重选，摘要和简单输入改为两列顶部标签，警告使用公共 Alert，窄视口弹窗宽度随窗口收缩，服务及执行配置不展示内部 ID。联合 Reactor 与 105 项后端测试通过（AutoExec 55、Informant 50），前端模块 325 项测试、定向 ESLint、差异检查和两模块 779 键 Java 语言资源校验通过。隔离 Chrome 使用真实 TsDialog、TsFormItem 和 AutoExec 类型控件、真实专用解析结果，检查 1500px/720px、明暗主题、警告位置、标签到控件间距、窗口无右侧裁切，以及配置保存无控制台错误。此为隔离浏览器验证，未部署、修改业务数据库或启动真实作业；需要同步更新 AutoExec、Informant 后端与 Informant 前端。

- 2026-11-17 确认页基本信息按反馈改为左右标签内容，保留一行两列；下方原生类型输入保持顶部标签以避免浮动布局错位。11 项前端定向测试、ESLint 和隔离 Chrome 宽窄视口明暗主题检查通过。服务产品搜索原先后端忽略组件发送的 `keyword`，现 API 声明并由 Service 传给 Mapper，SQL 使用绑定关键字进行忽略大小写的包含匹配，空关键字返回全部有效产品；保留去重、排序和已选产品回显。真实 MyBatis/H2 覆盖大小写、空白、子串、无匹配及 `defaultValue`/`valueList` 回显，23 项测试与 Informant Reactor 编译通过。未访问真实业务数据库或部署，产品搜索修复需要更新 Informant 后端。

- 2026-11-17 单击执行交互：执行配置与目标参数改为公共 TsFormItem 左侧标签，无额外样式；移除单独核对与二次确认按钮，执行前自动完成控件校验、完整预览和快照一致性检查。成功结果由全景图父层独立持有，关闭输入窗口后显示提交成功及作业详情链接；启动失败保留原作业和提交快照重试。328 项前端模块测试、三处 Vue ESLint、差异检查通过。隔离 Chrome 使用真实页面、TsDialog 和原生参数控件验证宽窄视口明暗主题、标签输入同行、校验阻止提交、连续点击仅一次提交、完整预览在提交前、输入窗关闭与结果窗链接。执行接口使用隔离替身返回虚拟作业，未调用真实执行或 Runner；本次仅需更新 Informant 前端。

- 2026-11-17 输入间距与默认值：执行输入行复用 `mb-md` 增加间距，摘要隐藏下方已有直接输入或关联作业参数输入的重复字段，场景默认值首次回填且不覆盖人工清空。AutoExec 专用解析将已生效策略及当前策略的默认数量同步回填 `executeParamList.value`，修复顶层显示 32、输入仍为空的不一致；非当前策略的人工数量保持原样。329 项前端测试、ESLint 和差异检查通过；AutoExec Reactor 与 58 项专用测试、双模块 H2 隔离集成通过。隔离 Chrome 检查明暗主题、宽窄视口行间距、默认 32 真实输入值及原单击提交/结果链接交互。未执行真实作业；此次需更新 Informant 前端和 AutoExec 后端。

- 2026-11-17 结果提示与记录页：结果窗移除绿色 Alert，以普通文字“作业已生成”加实际作业名称链接展示，名称取本次完整预检解析的作业名。记录页 CombineSearcher 设置 `labelPosition="left"`，状态复用 CommonStatus 并使用既有状态值和译文，执行人复用 UserCard 并保留原 AutoExec 执行人字段，筛选契约不变。330 项前端模块测试、三处 Vue ESLint、差异检查通过；隔离 Chrome 验证明暗主题普通结果提示与名称链接、CommonStatus/UserCard 实际渲染、搜索标签左右布局，无运行错误。接口使用替身，未执行真实作业；仅需更新 Informant 前端。

- 2026-11-17 记录主机可读信息：记录接口在作业权限、状态过滤与分页结束后，对当前页去重 UUID 批量读取 `uuid/hostname/ip` 安全字段；响应保留身份 UUID，并增加 `hostname/ip`，前端主机列显示主机名和地址。未新增数据列或回填历史数据，节点删除不影响记录及总数。Informant Reactor 与 24 项持久化测试通过，覆盖当前页批量读取、过滤分页、删除节点和作业、空字段、敏感列排除；331 项前端测试、ESLint、差异检查和隔离 Chrome 明暗主题主机文字检查通过。未访问真实数据库或部署；需同步更新 Informant 后端及前端。

后端验证从 `neatlogic-build-root` 执行：

```sh
mvn -Pdevelop,commercial -pl ../neatlogic-informant,../neatlogic-autoexec -am -Dexec.skip=true '-Dtest=InformantQuickTool*,AutoexecExecutableVersionMapperTest,AutoexecReadyCombopJobTest,AutoexecJobTagentRouteTest,AutoexecJobTargetAccessTest,Autoexec*Param*Test,InformantCiMappingPersistenceTest,InformantServicePanoramaTest' -Dsurefire.failIfNoSpecifiedTests=false test
```

前端验证从 Informant 前端独立仓库执行：

```sh
node --test tests/quicktool.test.mjs tests/panorama-page.test.mjs tests/panorama-layout.test.mjs tests/service-management.test.mjs
```

## 初版变更文件（历史记录）

后续保存校验修复：参数映射表的 scoped-slot 引用按参数 key 独立命名，兼容单对象和数组，逐行校验可编辑项；执行页核对同样兼容引用形态。新增 5 项真实 Vue 挂载回归，前端 323 项测试及 ESLint 通过。隔离浏览器使用真实组件复现修正前 `every is not a function`，修正后保存请求正常进入模块 API 替身；未保存真实租户配置。

菜单使用 Informant 自身的 `router.js`、`config.js` 和菜单行为测试。曾新增的公共布局/侧栏插槽及模块动态菜单组件均已撤销，公共框架前端保持原样。

### neatlogic-autoexec-base

- `src/main/java/neatlogic/framework/autoexec/crossover/IAutoexecQuickExecutionCrossoverService.java`
- `src/main/java/neatlogic/framework/autoexec/dto/job/AutoexecQuickJobRequestVo.java`

### neatlogic-autoexec

- `pom.xml`（H2 仅为测试依赖）
- `src/main/java/neatlogic/module/autoexec/dao/mapper/AutoexecQuickExecutionMapper.java`
- `src/main/java/neatlogic/module/autoexec/dao/mapper/AutoexecQuickExecutionMapper.xml`
- `src/main/java/neatlogic/module/autoexec/service/AutoexecQuickExecutionServiceImpl.java`
- `src/test/java/neatlogic/module/autoexec/service/AutoexecQuickExecutionListTest.java`
- `src/test/java/neatlogic/module/autoexec/service/AutoexecQuickExecutionServiceTest.java`
- `src/test/java/neatlogic/module/autoexec/service/AutoexecQuickJobResolverTest.java`

### neatlogic-informant-base

- `src/main/java/neatlogic/framework/informant/auth/label/INFORMANT_QUICKTOOL_AUDIT.java`
- `src/main/java/neatlogic/framework/informant/auth/label/INFORMANT_QUICKTOOL_CONFIG.java`
- `src/main/java/neatlogic/framework/informant/auth/label/INFORMANT_QUICKTOOL_EXECUTE.java`
- `src/main/java/neatlogic/framework/informant/dto/InformantQuickToolConfigVo.java`
- `src/main/java/neatlogic/framework/informant/dto/InformantQuickToolRecordVo.java`

### neatlogic-informant

- `pom.xml`
- `src/main/java/neatlogic/module/informant/api/quicktool/DeleteQuickToolConfigApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/ExecuteQuickToolApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/GetQuickToolApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/GetQuickToolCapabilityApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/GetQuickToolConfigApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/ListAvailableQuickToolApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/ListQuickToolApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/ListQuickToolProductApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/ListQuickToolRecordConfigApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/ListQuickToolEntryApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/PreviewQuickToolApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/SaveQuickToolConfigApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/SearchQuickToolConfigApi.java`
- `src/main/java/neatlogic/module/informant/api/quicktool/SearchQuickToolRecordApi.java`
- `src/main/java/neatlogic/module/informant/auditconfig/handler/InformantQuickToolRecordCleaner.java`
- `src/main/java/neatlogic/module/informant/dao/mapper/InformantQuickToolMapper.java`
- `src/main/java/neatlogic/module/informant/dao/mapper/InformantQuickToolMapper.xml`
- `src/main/java/neatlogic/module/informant/service/InformantQuickToolService.java`
- `src/main/java/neatlogic/module/informant/service/impl/InformantQuickToolServiceImpl.java`
- `src/main/resources/neatlogic/resources/informant/changelog/2026-11-16/neatlogic_tenant.sql`
- `src/main/resources/neatlogic/resources/informant/i18n/language_en.json`
- `src/main/resources/neatlogic/resources/informant/i18n/language_zh.json`
- `src/main/resources/neatlogic/resources/informant/sqldefine/index-en.json`
- `src/main/resources/neatlogic/resources/informant/sqldefine/index.json`
- `src/main/resources/neatlogic/resources/informant/sqldefine/tables/informant_quick_tool_config-en.json`
- `src/main/resources/neatlogic/resources/informant/sqldefine/tables/informant_quick_tool_config.json`
- `src/main/resources/neatlogic/resources/informant/sqldefine/tables/informant_quick_tool_record-en.json`
- `src/main/resources/neatlogic/resources/informant/sqldefine/tables/informant_quick_tool_record.json`
- `src/test/java/neatlogic/module/informant/service/InformantQuickToolPersistenceTest.java`

### neatlogic-web/src/commercial-module/informant

- `api/api.js`
- `api/quicktool.js`
- `languages/term/en.json`
- `languages/term/zh.json`
- `pages/informant/components/informant-service-panorama-detail.vue`
- `pages/informant/components/informant-service-panorama-quicktool-menu.js`
- `pages/informant/informant-service-topo.vue`
- `pages/quicktool/capability.js`
- `pages/quicktool/quicktool-config-edit.vue`
- `pages/quicktool/quicktool-config.vue`
- `pages/quicktool/quicktool-execute.vue`
- `pages/quicktool/quicktool-result.vue`
- `pages/quicktool/quicktool-record.vue`
- `pages/quicktool/components/typed-value.vue`
- `pages/quicktool/components/mapping-table.vue`
- `router.js`
- `tests/panorama-page.test.mjs`
- `tests/panorama-quicktool-entry.test.mjs`
- `tests/panorama-quicktool-menu-events.test.mjs`
- `tests/quicktool.test.mjs`

- `tests/quicktool-record-components.test.mjs`
