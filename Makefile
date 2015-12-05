.PHONY: clean bundle

generator: generator.c
	$(CC) -o generator `sdl-config --cflags --libs` -lm generator.c

bundle: generator
	sh makeAppBundle

clean: 
	$(RM) generator

