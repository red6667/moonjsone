# MoonJSONE

MoonJSONE 是 MoonBit 的 JSON-e 结构化模板解释器。输入是 JSON 模板和 JSON 上下文，输出是可继续校验、保存或交给其他系统的 JSON。适合重复生成部署配置、CI 任务矩阵和测试数据；不负责执行生成的任务。模块：`red6667/moonjsone@0.1.1`。

## 功能和兼容范围

实现 JSON-e 的 16 个操作符、20 个内置函数、表达式优先级、对象与数组访问、切片、字符串插值、局部作用域和省略标记。API 为 `render`、`evaluate_expression` 和 JSON 请求入口 `execute`，不依赖宿主语言 eval。

固定参考为 json-e/json-e `87167b21ed1a4040cc48cfabb61a62c77e6ac0fd`（JS 包版本 4.8.4）。全部 1,175 个上游规范用例均保留为 MoonBit 断言，比较结构化结果或是否应当拒绝；不要求上游错误文本一致。官方 Python、JavaScript 实现也已在固定时钟下跑完同一语料，均符合规范预期。详见 [兼容契约](docs/compatibility.md) 和 [参考锁](tests/fixtures/source-lock.json)。这些是固定语料的验证结果，不代表未来版本或任意输入均兼容。

操作符：`$eval`、`$json`、`$if`、`$flatten`、`$flattenDeep`、`$fromNow`、`$let`、`$map`、`$reduce`、`$find`、`$match`、`$switch`、`$merge`、`$mergeDeep`、`$sort`、`$reverse`。共 **16** 个操作符。内置函数：`min`、`max`、`sqrt`、`abs`、`ceil`、`floor`、`range`、`lowercase`、`uppercase`、`len`、`str`、`number`、`strip`、`rstrip`、`lstrip`、`join`、`split`、`fromNow`、`typeof`、`defined`，共 **20** 个。

## 安装与快速开始

需要 MoonBit 工具链；本地验证使用 Moon 0.1.20261021、Moonc 0.10.17。纯核心使用 wasm-gc、wasm、js、native 后端；JavaScript 运行需要 Node.js，native 运行需要 C 编译器。

```sh
moon add red6667/moonjsone@0.1.1
```

在消费者 `moon.pkg` 中加入：

```moonbit
import { "red6667/moonjsone" }
```

```moonbit
///|
fn main raise {
  let template : Json = {
    "$map": { "$eval": "regions" },
    "each(region)": { "name": "${service}-${region}", "replicas": { "$eval": "n" } },
  }
  let context : Json = { "service": "catalog", "regions": ["east", "west"], "n": 3 }
  let result = @moonjsone.render(template, context)
  println(result.stringify())
}
```

得到两个配置对象，名称分别为 `catalog-east`、`catalog-west`，副本数都是 3。`$eval` 保留 JSON 类型；`${...}` 只做标量字符串插值。`$if` 没有命中且没有对应分支时会省略字段或数组元素；它与 JSON null 不同。对象缺失属性的点访问报错，方括号访问返回 null。

## 三个可运行流程

```sh
moon run examples/deployment
moon run examples/matrix
moon run examples/payloads
```

- 部署工具把服务名、区域和副本数交给模板，得到两份 Deployment 结构；输出可交给外部部署工具，示例不连接集群。
- CI 配置生成器把两个系统和两个运行时版本作笛卡尔积，输出四个任务对象；不启动 CI 作业。
- 测试系统输入数量与前缀，通过 range 和 map 生成三条带金额和开关的确定性 JSON 数据；便于快照和接口夹具复用。

`python scripts/smoke.py --target wasm-gc` 对输出字段作实际断言，也检查 CLI 批次中错误请求不会影响下一项。

## API 和命令行

`render(template, context, now?, max_steps?, max_depth?, max_items?)` 返回 Json；`evaluate_expression(source, context, ...)` 只解释表达式。二者抛出 `TemplateError::Invalid(message)` 或 `TemplateError::Limit(message)`。上下文必须是对象，顶层名称为 ASCII 标识符，可覆盖内置函数。

`execute(input)` 输入一个请求对象或至多 1,000 项的数组；每项返回 `{ "ok": true, "result": ... }` 或包含 `category`、`message` 的错误对象。允许字段为 `template` 或 `expression`、可选 `context` 和 `now`。

```sh
moon run cmd/main -- '{"expression":"range(0,3)","context":{}}'
moon run cmd/main -- '{"template":{"name":"${name}"},"context":{"name":"catalog"}}'
```

上例为 POSIX shell 写法；PowerShell 对原生命令参数的引号规则可能不同，自动化可用 Python 的 subprocess 参数数组传递 JSON，见 `scripts/smoke.py`。

## 时钟、限制与非目标

为可复现性，默认 now 是 `1970-01-01T00:00:00.000Z`，调用方应传 `now="2026-10-30T00:00:00.000Z"` 或上下文 now。接受毫秒精度 UTC 格式，日期范围为 0001..9999；相对一年按 365 天、一月按 30 天，与参考语义一致。默认预算为 1,000,000 步、128 层、每个集合或字符串 100,000 项/UTF-16 单元；深度最多配置到 256。字符串预算同样检查输入和表达式中间值，拼接在分配结果前检查长度。CLI 请求最大 4,000,000 单元。预算是解释器保护机制，不能替代操作系统资源隔离。

数值为有限 binary64，索引和 range 参数受有符号 32 位范围约束；非有限结果拒绝输出。JSON 上下文不接受宿主函数；未调用函数不能输出。没有文件导入、网络、宿主代码执行；不解析 YAML，不兼容 Jsonnet、JSONata 的输入语言，不代替 JSON Schema 验证器。错误消息与上游不同，资源预算可能拒绝上游允许的工作。Unicode 大小写沿用 MoonBit core，当前语料不能证明所有语言的大小写规则一致。

## 检查与测试

```sh
moon info
moon fmt
moon check --deny-warn
moon test --deny-warn
moon build --deny-warn
python scripts/check_reference.py
python scripts/smoke.py --target wasm-gc
python scripts/audit.py
```

对 js、wasm、native 可增加 `--target`。GitHub Actions 对四个目标分别执行严格 check/test/build、参考夹具校验和三个示例。Windows 本地没有 C 编译器，native 运行以实际 Linux CI 结果为准。测试代码、上游规范、示例和生成接口不计入核心生产代码量。

## 许可与来源

参考移植 json-e/json-e 的语言和算法约定，使用 [MPL-2.0](LICENSE)，来源及修改范围见 [NOTICE](NOTICE)。核心是纯 MoonBit 重新实现，原始上游规范和生成测试保留来源与许可，不把上游测试计作原创生产代码。项目使用 MoonBit core；生成过程使用 AI 辅助，详见 [AI-USE.md](AI-USE.md)。
