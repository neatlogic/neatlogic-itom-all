# NeatLogic 项目开发规范（持续补充）

本文档用于记录当前仓库的开发约束、模块边界和实现习惯。
后续如有新增说明，应优先更新本文件，作为功能开发时的默认参考。

## 1. 项目结构总览

- 项目为前后端分离架构。
- 前端代码位于 `neatlogic-web`。
- 后端公共基础框架位于 `neatlogic-framework`。
- 业务能力按模块拆分，模块命名通常为 `neatlogic-xxx`。
- 每个业务模块通常存在一个对应基础模块 `neatlogic-xxx-base`。
- `neatlogic-itom-all` 主要用于聚合管理、整体打包和集中查看代码，不作为日常业务改码的主落点。
- 允许在 `neatlogic-itom-all` 中维护说明文档、开发规范等辅助内容。
- 实际业务代码修改应直接进入对应模块目录，例如 `neatlogic-xxx`、`neatlogic-xxx-base`、`neatlogic-web`、`neatlogic-framework`。

## 2. 模块职责划分

### 2.1 前端

- 所有前端页面、交互、前端接口接入逻辑默认放在 `neatlogic-web`。
- 开发新功能时，需要先判断是新增页面、扩展现有页面，还是仅调整接口调用。

### 2.2 Framework 层

- `neatlogic-framework` 是全局基础框架层。
- 该层 Bean 由 `root-context` 加载。
- 由于 `root-context` 对所有子模块可见，因此 framework 中的 Bean 可以被所有子模块引用。
- 通用能力、跨模块复用能力，优先评估是否应沉淀到 `neatlogic-framework`。

### 2.3 业务模块

- 业务模块以 `neatlogic-xxx` 形式存在。
- 模块间需要保持相对隔离，避免直接形成双向业务依赖。
- 开发时应优先将业务实现收敛在所属模块内，不随意把业务逻辑下沉到无关公共层。

### 2.4 Base 模块

- `neatlogic-xxx-base` 是对应业务模块 `neatlogic-xxx` 的基础模块。
- 其主要作用是承载基础类、公共定义和可被其他模块引用的能力。
- 设计目的之一是绕开 Maven 不允许交叉引用的问题。

## 3. Maven 依赖约束

- Maven 层面不允许模块之间直接交叉引用。
- 如果模块 A 和模块 B 之间需要互相使用一部分能力，通常采用以下方式：
  - A 依赖 `B-base`
  - B 依赖 `A-base`
- 因此，跨模块共享的类、接口、基础定义，应优先放入对应的 `-base` 模块，而不是直接放入业务模块实现中。

## 4. Spring 模块化机制

- 系统的模块化是通过 Spring 的 Servlet 分层实现的。
- 每个模块都是一个独立的 `DispatchServlet` 实例。
- 这样做的目的是隔离各模块自身的 Bean，减少模块间 Bean 冲突和耦合。
- `neatlogic-framework` 中的 Bean 因为由 `root-context` 加载，所以天然可被各子模块访问。

## 5. 当前默认开发判断规则

在未拿到更细规范前，新增功能默认遵循以下判断顺序：

1. 前端变更放在 `neatlogic-web`。
2. 纯业务逻辑优先放在所属 `neatlogic-xxx` 模块。
3. 需要被其他模块引用的基础定义，优先考虑放入 `neatlogic-xxx-base`。
4. 明显属于全局公共能力的内容，再考虑放入 `neatlogic-framework`。
5. 涉及 Spring Bean、配置加载、接口注册时，先判断其归属：
   - 全局共享能力：考虑 `root-context` / `neatlogic-framework`
   - 模块私有能力：保持在对应模块的 `DispatchServlet` 上下文内

## 6. 后端开发规范

### 6.1 实体类规范

- 项目中的实体类统一命名为 `xxxVo`。
- `Vo` 类主要放在对应 `neatlogic-xxx-base` 模块的 `dto` 包中。
- `Vo` 类属性使用专用注解 `@EntityField` 定义。
- `@EntityField` 的主要作用之一是支撑接口说明和字段元数据描述。

### 6.2 MyBatis Mapper 放置规范

- MyBatis 配置文件统一放在 `dao.mapper` 相关包路径下。
- 如果 Mapper Bean 只在当前模块内部使用，则放在：
  - `neatlogic-xxx` 项目中的 `neatlogic.module.xxx.dao.mapper`
- 如果 Mapper Bean 未来可能被其他模块引用，则放在：
  - `neatlogic-xxx-base` 项目中的 `neatlogic.framework.xxx.dao.mapper`
- 判断标准不是“当前有没有复用”，而是“是否具备跨模块复用可能性”。

### 6.3 API 入口规范

- 项目所有入口都已经 API 化。
- 统一入口为 `com.neatlogic.autoexecrunner.web.ApiDispatcher`。
- 开发接口时，不需要额外创建 `Controller` 文件，也不需要在控制器中定义多个入口方法。
- 只要某个 Bean 实现了 `IApiComponent`，它就是一个独立接口。
- 针对普通访问、上传等不同类型接口，项目中已有对应基础类可继承，开发时应优先参考现有实现。
- API 实现类一般放在 `neatlogic.module.xxx.api` 包下。
- 可以根据具体功能继续划分二级包，例如 `neatlogic.module.ai.api.rag`。
- API 类命名通常采用“动作 + 领域对象 + Api”的形式。
- 例如查询 RAG 数据集的接口命名可为 `SearchRagDatasetApi`。
- 功能开发时，可以优先查找同模块下已有同类 API 实现作为参考样例。

### 6.4 常规功能实现方式

- 最简单的功能通常做法是：
  - 创建一个接口实现类
  - 在接口实现类中直接引用 Mapper
  - 通过 Mapper 完成数据库访问
- 接口实现类通常同时承担以下职责：
  - 权限控制
  - 事务控制
  - 参数说明
  - 接口元数据定义
- 当业务复杂度提升后，可以引入 `Service` 类承载业务逻辑。
- 复杂场景下的组织方式可以按传统 MVC / 分层架构理解，但入口层仍然遵循项目自身的 API 组件规范。
- 当用户指定“在某模块新增功能”时，默认开发步骤是：
  - 先进入对应业务模块
  - 先创建 API 实现类
  - 再补充 Mapper、SQL、Vo、Service 等配套实现

### 6.5 AI 模块当前已知约定

- AI 模块的 API 实现类放在 `neatlogic.module.ai.api` 下。
- 如果是 RAG 相关功能，可继续放在 `neatlogic.module.ai.api.rag` 等二级包中。
- 开发 RAG 能力时，可优先参考已有的 `SearchRagDatasetApi` 实现。
- 当前参考样例路径：
  - `neatlogic-ai/src/main/java/neatlogic/module/ai/api/rag/SearchRagDatasetApi.java`
  - `neatlogic-ai/src/main/java/neatlogic/module/ai/dao/mapper/RagMapper.java`
  - `neatlogic-ai/src/main/java/neatlogic/module/ai/dao/mapper/RagMapper.xml`

### 6.6 Mapper 与 SQL 组织规范

- SQL 语句统一写在 XML 中，不直接写在注解里。
- AI 模块相关 Mapper 实际放在 `neatlogic.module.ai.dao.mapper`。
- Mapper 一般按功能划分文件。
- 如果是 RAG 相关功能，通常创建：
  - `RagMapper.java`
  - `RagMapper.xml`
- 具体 SQL 写在 `RagMapper.xml` 中。
- MyBatis `mapper namespace` 与 Mapper 接口全限定名保持一致。
- 常见做法是：
  - 在 XML 中先抽公共 `<sql>` 片段
  - 列表查询与数量查询共用相同筛选条件
  - 列表接口通常提供 `searchXxx` 与 `searchXxxCount` 两个方法

### 6.7 API 实现样式参考

- API 类通常继承项目内现成的基础 API 类，而不是直接从零实现控制器入口。
- API 元数据通常在实现类中声明，包括：
  - 权限注解
  - `@Description`
  - `@Input`
  - `@Output`
  - `getToken`
  - `getName`
  - `getConfig`
- `myDoService` 中的常见写法是：
  - 把 `JSONObject` 转成对应 `Vo`
  - 调用 Mapper 查询列表
  - 在列表非空时补充 count
  - 使用 `TableResultUtil` 返回分页结果

## 7. 当前已知的明确禁忌

- 不要把 `neatlogic-itom-all` 当作业务功能改造入口直接改代码。
- 除文档、规范、辅助说明外，业务实现应落在真实模块目录中。
- 不要为普通接口需求额外创建传统 `Controller` 入口，优先使用 `IApiComponent` 体系。

## 8. 待补充信息

以下信息尚未明确，后续应继续补充进本文档：

- 命名规范
- 数据库变更规范
- 接口设计规范
- 模块间调用禁忌
- 一个“标准实现”的参考功能位置
- 本地启动、联调、测试、构建命令
- 代码提交、分支、评审要求
- 功能验收标准

## 9. 前端开发规范

### 9.1 前端项目与模块归属

- 前端项目位于 `neatlogic-web`。
- 页面源码位于 `neatlogic-web/src` 下。
- 商业模块放在 `src/commercial-module`。
- 社区模块放在 `src/community-module`。
- AI 模块属于商业模块，应在 `src/commercial-module/ai` 下开发。

### 9.2 模块目录约定

- 每个前端模块目录通常包含以下内容：
  - `api`
  - `pages`
  - `import.js`
  - `router.js`
- `api` 用于配置后端 API 调用文件。
- `pages` 用于存放页面级 `.vue` 文件。
- `import.js` 用于把模块自己的组件注册到全局，保证静态编译时可以找到模块特定组件。
- `router.js` 用于管理模块菜单和路由。

### 9.3 AI 前端模块当前已知结构

- AI 前端模块路径：`neatlogic-web/src/commercial-module/ai`
- 当前可见子目录包括：
  - `api`
  - `pages`
  - `languages`
- 当前可见页面包括：
  - `pages/system/ai-model-manage.vue`
  - `pages/system/ai-model-edit.vue`
  - `pages/system/ai-agent-manage.vue`
  - `pages/system/ai-agent-edit.vue`
  - `pages/rag/rag-dataset-manage.vue`
  - `pages/topnav/ai-chat-nav.vue`
  - `pages/topnav/ai-chat-dialog.vue`

### 9.4 前端样式约束

- 页面开发时，样式 class 应优先在 `neatlogic-web/src/resources/assets/css/common.less` 中查找并复用。
- 只有在 `common.less` 中没有合适现成样式时，才允许新增页面局部样式。
- 如果新增页面样式，默认使用 `<style scoped lang="less">`。
- 不应编写未加 `scoped` 的页面级样式，避免样式影响范围扩大到其他页面。
- 开发时应尽量减少页面内新增 class 数量，优先通过已有通用 class 组合完成布局和展示。

## 9. 维护约定

- 本文件作为项目开发规范的持续沉淀文档。
- 后续你口述新的项目规则后，应直接追加或修订到本文件。
- 当规范与代码现状不一致时，需要额外标注“历史实现”和“当前推荐做法”的区别。
