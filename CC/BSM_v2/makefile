objects = normdist.o BS_Greeks_call.o \
    BS_Greeks_put.o BS_call_Price.o \
	BS_put_Price.o BS_delta_call.o \
	BS_delta_put.o main_BS_yyf.o

compl = nvcc
	
main_yyf: $(objects)
	$(compl) -o main_yyf $(objects)

normdist.o: normdist.cpp normdist.h
	$(compl) -c normdist.cpp

BS_Greeks_call.o: BS_Greeks_call.cpp normdist.h
	$(compl) -c BS_Greeks_call.cpp

BS_Greeks_put.o: BS_Greeks_put.cpp normdist.h
	$(compl) -c BS_Greeks_put.cpp

BS_call_Price.o: BS_call_Price.cpp normdist.h
	$(compl) -c BS_call_Price.cpp

BS_put_Price.o: BS_put_Price.cpp normdist.h
	$(compl) -c BS_put_Price.cpp

BS_delta_call.o: BS_delta_call.cpp normdist.h
	$(compl) -c BS_delta_call.cpp

BS_delta_put.o: BS_delta_put.cpp normdist.h
	$(compl) -c BS_delta_put.cpp

main_BS_yyf.o: main_BS_yyf.cpp bs.h
	$(compl) -c main_BS_yyf.cpp

clean: 
	rm $(objects)