-- Configure LLama LLM
vim.g.llama_config = {
	endpoint = "http://10.0.20.158:8080/infill",
	api_key = "",
	n_prefix = 256,
	n_suffix = 64,
	n_predict = 256,
	t_max_prompt_ms = 500,
	t_max_predict_ms = 500,
	show_info = 2,
	auto_fim = true,
	max_line_suffix = 8,
	max_cache_keys = 256,
	ring_n_chunks = 8,
	ring_chunk_size = 32,
	ring_scope = 512,
	ring_update_ms = 1000,
}

-- require("gen").setup({ model = "codegemma" })
