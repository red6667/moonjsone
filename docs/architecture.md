# Architecture and acceptance contract

The pure engine converts Json into an internal value algebra with a distinct omission marker and builtin function references. A tokenizer and precedence parser produce a reusable AST. A bounded evaluator handles expressions independently of recursive template evaluation. Operators explicitly validate additional properties and scope variables. No host eval, network, file imports or unbounded user recursion.

Reference: json-e/json-e 87167b21ed1a4040cc48cfabb61a62c77e6ac0fd, MPL-2.0. The entire specification corpus will be inventoried and compared against pinned upstream behavior, including expected errors and a fixed clock. A passing local case is not universal compatibility proof.

Required workflows: deployment configuration generation; CI task matrix generation without execution; deterministic test payload generation. Library and CLI share engine semantics. Four backend CI must run actual tests and examples. Depth, steps and output limits are additional protective behavior and have their own tests.

Completion requires all declared operators and builtins, published exact source/CI and fresh consumer proof, source attribution, a complete Chinese README and a private application outside this repository. No official acceptance is claimed.
