function get_git_info()
	local abs_path = vim.fn.expand("%:p")
	local git_root = vim.fn.systemlist(
		"git -C " .. vim.fn.escape(vim.fn.fnamemodify(abs_path, ":h"), " ") .. " rev-parse --show-toplevel"
	)[1]

	if vim.v.shell_error ~= 0 then
		return
	end

	local git_repo = vim.fn.system("git remote get-url origin"):match("([^/:]+/[^/.]+)%.?[^/]*$"):gsub("\n", "")
	local git_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")

	return {
		file = vim.fn.fnamemodify(abs_path, ":s?" .. git_root .. "/??"),
		branch = git_branch,
		repo = git_repo,
	}
end

vim.keymap.set("v", "<Leader>gy", function()
	local git_info = get_git_info()
	if git_info == nil then
		vim.notify("Failed to get git info", vim.log.levels.ERROR)
		return
	end

	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")

	local message = string.format(
		"https://github.com/%s/blob/%s/%s#L%d-L%d",
		git_info.repo,
		git_info.branch,
		git_info.file,
		start_line,
		end_line
	)
	vim.fn.setreg("+", message)
	vim.notify("Copied:\n\t" .. message, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Copy GitHub Link" })
