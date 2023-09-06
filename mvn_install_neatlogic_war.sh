#!/bin/bash

# 定义项目目录列表
projects=(
  "neatlogic-parent"
  "neatlogic-framework"
  "neatlogic-rdm-base"
  "neatlogic-report-base"
  "neatlogic-cmdb-base"
  "neatlogic-tagent-base"
  "neatlogic-autoexec-base"
  "neatlogic-inspect-base"
  "neatlogic-deploy-base"
  "neatlogic-dashboard-base"
  "neatlogic-knowledge-base"
  "neatlogic-itsm-base"
  "neatlogic-event-base"
  "neatlogic-change-base"
  "neatlogic-autoexec"
  "neatlogic-change"
  "neatlogic-cmdb"
  "neatlogic-dashboard"
  "neatlogic-deploy"
  "neatlogic-document-online"
  "neatlogic-event"
  "neatlogic-inspect"
  "neatlogic-itsm"
  "neatlogic-knowledge"
  "neatlogic-pbc"
  "neatlogic-rdm"
  "neatlogic-report"
  "neatlogic-tagent"
  "neatlogic-tenant"
)

# 进入每个项目目录并执行mvn install命令
for project in "${projects[@]}"
do
  cd "$project" && mvn install -Pdevelop  && cd ..
done


cd neatlogic-webroot && mvn clean compile -U install -P develop