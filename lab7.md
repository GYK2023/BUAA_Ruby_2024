# Rails Server 启动过程说明文档

## 1. 执行 `rails server` 命令

当我们在命令行中执行 `rails server` 命令时，以下一系列事件会依次发生：

### 1.1 启动 Web 服务器

- **Web 服务器的选择**: 默认情况下，Rails 使用 Puma 作为 Web 服务器。Puma 是一个高性能的多线程 Web 服务器，能够处理并发请求。
- **进程启动**: 执行 `rails server` 后，Puma 进程被启动，监听指定的端口（默认是 `3000`）以接受 HTTP 请求。

### 1.2 加载 Rails 环境

- **加载 Rails 应用程序**: Puma 开始加载 Rails 应用程序。这包括加载应用程序的各个组件，例如模型、控制器和视图。
- **初始化**: Rails 会运行初始化代码（位于 `config/initializers` 目录中的文件），以配置应用程序的设置和加载必要的库。

## 2. 请求处理流程

- **请求到达**: 当有请求到达指定端口时，Puma 将接收到的请求交给 Rails 应用程序进行处理。
- **路由**: Rails 根据请求的路径和 HTTP 方法将请求路由到相应的控制器和动作。
- **响应生成**: 控制器处理请求后，生成相应的视图，并将结果返回给 Puma，最终发送给客户端。

## 3. Gemfile 的加载

Rails 使用 Bundler 来管理 gem 包。在执行 `rails server` 之前，Bundler 会读取 `Gemfile` 中列出的所有依赖项。

### 3.1 Gemfile 加载流程

- **读取 Gemfile**: Bundler 会解析 `Gemfile`，找出需要加载的 gem 包。
- **安装依赖**: 如果有 gem 包未安装，Bundler 会自动安装这些依赖项。
- **加载 gem 包**: 在 Rails 启动时，Bundler 会通过 `require` 语句加载 Gemfile 中的 gem 包到 Ruby 的环境中。这些 gem 包可能包括：
    - Rails 核心库
    - 数据库适配器
    - 中间件
    - 其他功能性 gem 包（如测试、日志、身份验证等）

### 3.2 自动加载

Rails 还利用了 Ruby 的 `autoload` 功能，按需加载文件。这意味着只有在实际需要使用某个类或模块时，Rails 才会加载它，优化了内存使用和性能。


通过执行 `rails server` 命令，Rails 应用程序的 Web 服务器启动并开始监听请求，同时应用程序环境和依赖的 gem 包也被加载。这一过程确保了请求能够被正确处理并生成响应。

