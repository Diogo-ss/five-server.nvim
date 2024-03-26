tests:
	timeout 100 nvim --headless --noplugin \
	    -u scripts/init.vim \
	    -c "PlenaryBustedDirectory tests/ { \
	            minimal_init = 'scripts/init.vim', \
	            sequential = true \
	        }"

docgen:
	timeout 100 nvim --headless --noplugin \
		-u scripts/init.vim \
		-c "luafile ./scripts/gendocs.lua" -c 'qa'

.PHONY: tests docgen
