JC =javac
.SUFFIXES:.java .class
.java.class:
	$(JC) $*.java

CLASSES = \
	HelloWorld.java \
	Stuff.java

default:CLASSES

classes:$(CLASSES:.java=.class)

clean:\
	$(RM) *.class
