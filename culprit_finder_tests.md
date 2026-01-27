# Tests for culprit-finder

# Basic Tests

### Standard run
Runs the culprit-finder for a specific repository and workflow within a given commit range.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=604898a5cd49af23567b6d3798fdac55e26faf13 \
  --end=92139262a50dca73af4e6bdaea08d5a65a2b3a11 \
  --workflow=dev_workflow.yml
```

### Run with url
Executes the finder using a direct GitHub Actions run URL instead of specifying repo, start, end, and workflow separately.
```shell
culprit-finder https://github.com/danielibarrola/test-gh-actions-2/actions/runs/20036196212 
```

### Run without cache
Runs the culprit-finder while explicitly disabling the cache to ensure all checks are performed fresh.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=604898a5cd49af23567b6d3798fdac55e26faf13 \
  --end=92139262a50dca73af4e6bdaea08d5a65a2b3a11 \
  --workflow=dev_workflow.yml \
  --no-cache
```

### Run tests with cache but there are no cached results
Tests the behavior when caching is enabled but no previous results exist for the specified range.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=880fdb2dad13663501769c9f84acc6e3b2d017d6 \
  --end=10fae47539f3fb12e0b69fc642d120b7dd5907bd \
  --workflow=dev_workflow.yml
```

### Run when there are no bad commits
Verifies that the tool correctly identifies when all commits in the range are successful (no culprit found).
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=0cacaba7b86d04a9d4dd82eb9a8e8ea91076afac \
  --end=9c5808bd1d2021e9ecfbd69242dc890f8b0c70a9 \
  --workflow=dev_workflow.yml
```

### Run where all commits are bad
Tests the scenario where every commit in the range is failing, making the first commit the culprit.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=6cbcb1c517ddd4609e38bc384f2bb7067ce23ecf \
  --end=432b87263d7ae11987eb518ed79c909f259450c2 \
  --workflow=dev_workflow.yml
```

### Run with env variables
Demonstrates how to pass environment variables to the workflow runs during the bisection process.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=80fd0c6704d325cc69ea9df52f11b84d54113094 \
  --end=1d3942fca650909f048eaef1685cc1b95ad9da19 \
  --workflow=dev_workflow.yml \
  --env hello=world test=sanson
```

### Run for jax fork
Examples of running the culprit-finder on a different repository (`jax-fork`) with specific workflows.
```shell
culprit-finder \
  --repo=google-ml-infra/jax-fork \
  --start=cb55e967291ff9b7d4c915b67ef172859cb6d2f6 \
  --end=167738b47820617940ba6c70e4a9b35371c1596c \
  --workflow=hello_world.yml
```

```shell
culprit-finder \
  --repo=google-ml-infra/jax-fork \
  --start=9918cf40d521c3d1c4f7a63ef1bda690ab12325a \
  --end=3c7b9d18027e8aba2d725995f6db45e0ce960ccd \
  --workflow=wheel_tests_continuous.yml
```

## Tests for specific jobs

### Run for test-gh-actions-2 repo with specific job (use job id)
Targeting a specific job within the workflow using its identifier.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=604898a5cd49af23567b6d3798fdac55e26faf13 \
  --end=92139262a50dca73af4e6bdaea08d5a65a2b3a11 \
  --workflow=dev_workflow.yml \
  --job=build
```

### Run for test-gh-actions-2 repo with specific job (use job name)
Targeting a specific job within the workflow using its display name.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=8046f292d0c3cc49a28150cef2972107db50cd16 \
  --end=c7957bfc2403a2dcc47a74c90036d95e75c2d0c4 \
  --workflow=dev_workflow.yml \
  --job="Test Development Environment"
```

### Run for specific job with url
Using direct URLs for specific jobs within a run to pinpoint failures.
```shell
culprit-finder https://github.com/danielibarrola/test-gh-actions-2/actions/runs/20036196212/job/57458302202
```

```shell
culprit-finder https://github.com/danielibarrola/test-gh-actions-2/actions/runs/21009845329/job/60401780141
```

```shell
culprit-finder https://github.com/danielibarrola/test-gh-actions-2/actions/runs/21038176172/job/60492030851
```

```shell
culprit-finder https://github.com/danielibarrola/test-gh-actions-2/actions/runs/21252924537/job/61159207103
```

```shell
culprit-finder https://github.com/google-ml-infra/jax-fork/actions/runs/21097883816/job/60678154032 # green commit https://github.com/google-ml-infra/jax-fork/actions/runs/21087849486/job/60654733045
```

## Tests for cross repo dependencies  
### Run test for cross repo dependencies with pinned deps
Finding the culprit when changes in a cross-repository dependency (using a pin file) might be responsible for the failure.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=aa81ffe9bb6bae1dcbb3bc116f031bcb7c92ee83 \
  --end=b5a65bf0bb3c26ade3639d0d732af098bdab0431 \
  --workflow=python_tests.yml \
  --cross-repo-dep=danielibarrola/python-hello-world \
  --dep-pin-file=py_hello_world.txt
```

### Run test for cross repo dependencies with floating deps
Finding the culprit when using floating dependencies from another repository.
```shell
culprit-finder \
  --repo=danielibarrola/test-gh-actions-2 \
  --start=6dc606fd4d05c2c00ed17bbdef51cade54ac0689 \
  --end=e1e43bae42d1482ba37535f906bc2cfedbda8a4c \
  --workflow=python_tests_head.yml \
  --cross-repo-dep=danielibarrola/python-hello-world
```