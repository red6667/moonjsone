# 新方向提案与查重记录（待参赛者确认）

日期：2026-10-30，Asia/Shanghai。状态：仅选题调研；未开始新项目实现、未预留题目、未创建仓库或发布。

## 建议：MoonJSONE——MoonBit JSON-e 结构化模板引擎

任务：将 JSON 值形式的模板和上下文参数求值为 JSON 结果，兼容既有 JSON-e 模板。上游 json-e/json-e 固定 SHA 87167b21ed1a4040cc48cfabb61a62c77e6ac0fd；MPL-2.0；README、许可证、规范、运算符说明、JS 实现和规范测试入口已保存。规范包含1175个title条目，这表示可供核对的用例库存，绝不代表本项目已实现或通过1175测试。

需求依据：上游README列出Taskcluster任务定义生成、AlterSchema声明式转换两种实际应用。拟面向MoonBit服务/部署工具作者、CI平台集成者、测试与数据工具作者；这些是拟支持的使用者，未声称已访谈或已有采用者。

三个端到端场景：
1. 同一服务模板+开发/测试/生产上下文 -> 条件、列表和对象合并求值 -> 可解析且保留数值/布尔类型的部署配置。
2. 平台事件+任务模板 -> 矩阵映射、过滤和归约 -> CI任务定义JSON；不执行任务、不接管调度器。
3. 测试参数矩阵+请求模板 -> 确定性JSON数据集；可嵌入MoonBit程序或经CLI批处理。

## 拟交付完整边界

- JSON-e表达式的词法、语法、优先级、求值、作用域、内置函数与错误行为。
- 插值、操作符转义、条件/省略、map/reduce/find/match/switch、浅层与深层合并、flatten、sort/reverse、json、fromNow及上游所列全部标准运算符；实现前固定上游规范版本并建立逐项清单。
- render(template, context)库API、可注入时间、步数/递归/输出限制、机器可读错误和CLI。
- 至少三个真实使用示例。纯MoonBit可移植核心，四后端CI；不使用宿主eval执行模板。
- 不承诺完整CI调度平台、Kubernetes资源语义验证、网络部署或通用编程语言。YAML如支持由适配层转换为JSON值，不另造YAML解析器。
- 不以少量操作符子集申报完整JSON-e。若标准行为无法兑现，先报告阻碍及影响，再讨论范围。

验收：固定版本全部规范条目分别记录通过/失败/不适用及理由；与上游JS实现进行完整输出和预期错误对照；时间固定；覆盖空值/空集合/Unicode/浮点/无效表达式/作用域/转义/嵌套/资源限制；补充随机结构与组合测试。当前仅调研，尚无实现通过结果。

## 跨领域候选比较

|问题域/候选|已有证据|决策|
|---|---|---|
|配置读取/HOCON|uiwcvb/hocon0.25.0和moonbitstack/moonconf0.1.0均提供HOCON语义；前者实际README/接口/源码已查看|直接重合，淘汰|
|观测/OpenMetrics|JYPeng487/moonopenmetrics0.1.1有解析/验证/编码/合并，且有Prometheus SDK；已查看前者接口/源码/测试|直接重合，淘汰|
|媒体/字幕|MaoDingA/moonpost0.2.1提供SRT/WebVTT/ASS解析、转换、重定时、QC；MoonCakes实际文档和仓库元信息已获取，已有注册表源码证据|核心任务重合，淘汰|
|结构化模板/JSON-e|未检出同名实现；JSONata/Jsonnet/文本模板有较强邻近性，详见下表|建议方向；待用户确认与最终反向门禁|

## 语义邻近矩阵

|项目|输入/接口与行为|与拟项目关系|
|---|---|---|
|pangbit/moonjsonnet0.2.2|Jsonnet源码字符串，惰性求值、继承、导入和语言标准库；evaluate(String)|高度相邻：都能生成配置。独立必要性只能建立在直接运行既有JSON-e数据结构模板、明确不同语言规范与跨后端嵌入，不能声称泛配置生成无人实现|
|rinnein/moonata0.11.0|JSONata表达式字符串+JSON数据；compile/evaluate，查询转换与函数注册|高度相邻：均做JSON转换，但无法直接解释JSON-e模板对象及其操作符/省略语义。现有JSONata用户无需迁移|
|mizchi/bitflow0.4.2|Starlark子集/工作流IR，DAG执行与缓存规划|同方向不同功能；拟项目只生成任务数据，不执行DAG或缓存|
|文本模板库|字符串模板 -> 文本输出|邻近；拟项目以类型化JSON值作为输入输出，并以JSON-e既有语言兼容作为价值，不以换皮模板宣传|

源码证据固定版本及README/API/测试在各repo目录。注意：已读取和抽查，未执行这些第三方项目测试。实际源码抽查深度有限，不能替代实现前的最终门禁。

## 检索范围与限制

已按osc2026-guide执行moon search（limit100）、MoonCakes详情、GitHub关联仓库源码/接口/测试检查。共保存32项关键词原始输出，具体数量以search-*.txt为准。包括hocon/openmetrics/webvtt/jsonata/jmespath/xliff/translation memory/srx/tmx/jsonnet/starlark/json-e/jsone/jolt等；json-e、translation等宽词达到100上限，不可当作穷尽。TMX虽然无同名结果，语义扩词找到了Across2005翻译记忆引擎，因此未选。

GitHub仓库搜索："json-e" language:MoonBit、jsone language:MoonBit、"json-e" moonbit均0，incomplete=false。"JSON-e" MoonBit in:readme返回3个项目（bit-vcs/bit-relay、gaato/kbbi-mcp、moonrockz/partiql），仅仓库元数据不足以排除实现，需后续核对README匹配上下文。未做认证GitHub代码全量检索。旧错误awesome仓库路径返回404，随后官方moonbitlang/awesome-moonbit成功，README中无json-e字样。

永久注册表对json-e/jsone/jsonnet无匹配；moonata已有登记；文本模板有多条；已读取相邻记录。此处无权宣称全网唯一、最终查重通过或主办方认可。用户确认后，需先补齐README命中核对、模板核心行为反向查重，并在固定注册表锁内重新查重与原子预留；发现成熟直接替代即暂停汇报，不强行实施。

