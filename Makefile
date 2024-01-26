fmt: format
format:
	@terraform fmt -recursive


init/%:
	@terraform -chdir=$(notdir $@) init

plan/%:
	@terraform -chdir=$(notdir $@) plan
