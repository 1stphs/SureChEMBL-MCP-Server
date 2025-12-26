# SureChEMBL MCP Server

一个用于访问 SureChEMBL 化学专利数据库的 MCP (Model Context Protocol) 服务器。

## 功能

- 🔍 专利搜索 - 按文本、关键词或标识符搜索专利
- 🧪 化学物质检索 - 按名称、SMILES、InChI 搜索化合物
- 📄 专利文档 - 获取带有化学注释的完整专利文档
- 📊 数据导出 - 批量导出化学数据 (CSV/XML)

## 快速开始

### 本地开发

```bash
# 安装依赖
npm install

# 编译
npm run build

# 以 Stdio 模式运行
npm start

# 以 SSE 模式运行 (端口 8106)
npm run start:sse
```

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| `SSE_PORT` | `8106` | SSE 服务器端口 |
| `MCP_TRANSPORT` | `stdio` | 传输模式 (`stdio` 或 `sse`) |

---

## Docker 部署

### 首次部署

```bash
# 1. 构建并启动服务
docker-compose up -d --build

# 2. 查看日志
docker-compose logs -f

# 3. 检查服务状态
curl http://localhost:8106/health
```

### 更新部署

```bash
# 1. 拉取最新代码
git pull

# 2. 重新构建并启动
docker-compose up -d --build

# 3. 清理旧镜像 (可选)
docker image prune -f
```

### 停止服务

```bash
# 停止服务
docker-compose down

# 停止并删除数据卷
docker-compose down -v
```

### 查看日志

```bash
# 实时查看日志
docker-compose logs -f

# 查看最近 100 行日志
docker-compose logs --tail=100
```

### 单独使用 Docker (不使用 docker-compose)

```bash
# 构建镜像
docker build -t surechembl-mcp-server .

# 运行容器
docker run -d \
  --name surechembl-mcp-server \
  -p 8106:8106 \
  --restart unless-stopped \
  surechembl-mcp-server

# 停止容器
docker stop surechembl-mcp-server

# 删除容器
docker rm surechembl-mcp-server
```

---

## MCP 客户端配置

### Cherry Studio / 其他 SSE 客户端

```
SSE URL: http://localhost:8106/sse
```

或者使用服务器 IP:

```
SSE URL: http://<your-server-ip>:8106/sse
```

### Claude Desktop (Stdio 模式)

编辑配置文件:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "surechembl": {
      "command": "node",
      "args": ["/path/to/surechembl-server/build/index.js"]
    }
  }
}
```

---

## API 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/health` | GET | 健康检查 |
| `/sse` | GET | SSE 连接端点 |
| `/messages` | POST | 消息接收端点 |

---

## 可用工具

### 专利搜索
- `search_patents` - 按关键词搜索专利
- `get_document_content` - 获取专利文档内容
- `get_patent_family` - 获取专利家族
- `search_by_patent_number` - 按专利号搜索

### 化学物质检索
- `search_chemicals_by_name` - 按名称搜索化合物
- `get_chemical_by_id` - 按 ID 获取化合物信息
- `search_by_smiles` - 按 SMILES 搜索
- `search_by_inchi` - 按 InChI 搜索

### 结构与可视化
- `get_chemical_image` - 生成化学结构图像
- `get_chemical_properties` - 获取分子属性

### 数据导出与分析
- `export_chemicals` - 批量导出化学数据
- `analyze_patent_chemistry` - 分析专利中的化学内容

### 高级分析
- `get_chemical_frequency` - 获取化学物质频率统计
- `search_similar_structures` - 相似结构搜索
- `get_patent_statistics` - 获取专利统计信息

---

## 故障排除

### 服务无法启动

```bash
# 检查端口是否被占用
lsof -i :8106

# 查看 Docker 日志
docker-compose logs
```

### 连接问题

```bash
# 测试健康检查
curl http://localhost:8106/health

# 测试 SSE 连接
curl -N http://localhost:8106/sse
```

### 重置服务

```bash
# 完全重置
docker-compose down -v
docker-compose up -d --build
```

---

## License

MIT License
