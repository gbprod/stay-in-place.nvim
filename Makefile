prepare:
	@git submodule update --depth 1 --init

test: prepare
	@nvim \
			--headless \
			--noplugin \
			-u spec/spec.vim \
			-c "PlenaryBustedDirectory spec/ { minimal_init = 'spec/spec.vim' }"

watch: prepare
	@echo -e '\nRunning tests on "spec/**/*_spec.lua" when any Lua file on "lua/" and "spec/" changes\n'
	@find spec/ lua/ -name '*.lua' | entr make test


