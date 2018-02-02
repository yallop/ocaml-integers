.PHONY: all clean test doc

all:
	jbuilder build

test:
	jbuilder runtest

doc:
	jbuilder build @doc

clean:
	jbuilder clean
