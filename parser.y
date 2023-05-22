%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>

    extern int yylex(void);
    extern char *yytext;
    extern int lineas;
    extern FILE *yyin;
    FILE * fsalidaRep;
    FILE * fsalidaSel;
    FILE * fsalidaFun;
    FILE * fsalidaStru;

    void yyerror(char *s);
%}

%union
{
    char *valor;
}
%token <valor> T_ID T_INT T_FLOAT T_IF T_ELSE T_SWITCH T_CASE T_FOR T_WHILE T_DO T_TDATO T_OPAARIT T_INCR2 T_COMA T_PTCOM T_OPRELACION T_OPASIG T_PA T_PC T_CA T_CC T_INCR T_ANDOR T_CHAR T_RETURN T_STRUCT T_DOSPTO T_BREAK T_CAR
%type <valor> argumentos
%type <valor> declaracion
%type <valor> id
%type <valor> conte
%type <valor> return
%type <valor> asignaciones
%type <valor> operArit
%type <valor> valores
%type <valor> cases
%type <valor> case
%type <valor> constantes
%start funciones
%%

/* definiciones principales */

funciones : funciones funcion|
            funcion;

funcion   : T_TDATO T_ID T_PA argumentos T_PC T_CA conte T_CC{
            if(!strcmp($1, "void")){
                if(strcmp($7,""))
                    yyerror("Documento no valido");
            }
            else if(!strcmp($7,""))
                    yyerror("Documento no valido");
                    fprintf(fsalidaFun, "Funcion:\t%s\nRetorno:\t%s\nArgumentos:\t%s\n========\n",$2, $7, $4);};

argumentos  :    T_TDATO T_ID                   {strcat($1," ");strcat($1,$2); $$=$1;}|
                T_TDATO T_ID T_COMA argumentos  {strcat($1," ");strcat($1,$2);strcat($1,", ");strcat($1,$4);$$=$1;}
                                                |{$$="";};
conte       :   elementos conte     {$$=$2;}|
                return              {$$=$1;}|{$$="";};
elementos:   declaracion|operaciones|estructuras;

declaracion :  T_TDATO id T_PTCOM                  {strcat($1," ");strcat($1,$2); $$ = $1;printf("\n Declaracion linea %d Valida \n", lineas);}|
                T_TDATO id T_PTCOM declaracion      {strcat($1," ");strcat($1,$2);strcat($1,", ");strcat($1,$4);$$=$1;}|

            T_TDATO id {printf ("\n\n Error en linea %d: Te falto poner el ; en la declaracion. ", lineas);};

id :        T_ID{$$=$1;}|
            T_ID T_COMA id {strcat($1, ","); strcat($1,$3); $$=$1;};

operaciones:    asignaciones T_PTCOM {printf("\n Asignacioin linea %d Valida \n", lineas);}|
                T_ID T_OPASIG T_CHAR {printf("\n Operacion linea %d Valida \n", lineas);}|
                operArit T_PTCOM     {printf("\n Operacion linea %d Valida \n", lineas);}|
                operaciones asignaciones T_PTCOM    {printf("\n Operacion linea %d Valida \n", lineas);}|
                operaciones operArit T_PTCOM        {printf("\n Operacion linea %d Valida \n", lineas);}|

                operArit    {printf("\n\n Error en linea %d: Te falto poner el ; en la operacion aritmetica. ", lineas);};

asignaciones:   T_ID T_OPASIG T_ID      {strcat($1,$2);strcat($1,$3);$$=$1;}|
                T_ID T_OPASIG T_INT     {strcat($1,$2);strcat($1,$3);$$=$1;}|
                T_ID T_OPASIG T_FLOAT   {strcat($1,$2);strcat($1,$3);$$=$1;}|
                T_OPASIG T_INT          {printf("\n\n Error en linea %d: Te falto poner la variable. ", lineas);};

operArit:       T_ID T_OPAARIT valores                  {strcat($1,$2);strcat($1,$3);$$=$1;}|
                T_ID T_OPASIG valores T_INCR valores    {strcat($1,$2);strcat($1,$3);strcat($1,$4);strcat($1,$5);$$ = $1;}|
                T_ID T_INCR2                            {strcat($1,$2);$$=$1;};

valores:        T_INT   {$$=$1;}|
                T_FLOAT {$$=$1;}|
                T_ID    {$$=$1;};

return:         T_RETURN T_PA T_ID T_PC T_PTCOM     {$$=$3;}|
                T_RETURN T_PA T_INT T_PC T_PTCOM    {$$=$3;}|
                T_RETURN T_PA T_FLOAT T_PC T_PTCOM  {$$=$3;};

estructuras:    estructuras estructurasCuerpo {}|
                estructurasCuerpo       {};

estructurasCuerpo:  estructuraAlgoritmo|struct;

estructuraAlgoritmo:    for|while|dowhile|if|ifElse|switch;

for:        T_FOR T_PA asignaciones T_PTCOM valores T_OPRELACION valores T_PTCOM operArit T_PC T_CA contsEstructura T_CC{
            strcat($5,$6);strcat($5,$7);
            fprintf(fsalidaRep, "EstructuraRepetitiva:\t%s\nAsignaciones:\t%s\nCondicion de paro:\t%s\nIncremento:\t%s\n========\n",$1, $3, $5, $9);};

while:      T_WHILE T_PA valores T_OPRELACION valores T_PC T_CA contsEstructura T_CC{
            strcat($3,$4);strcat($3,$5);
            fprintf(fsalidaRep, "EstructuraRepetitiva:\t%s\nCondicion de paro:\t%s\n========\n",$1, $3);};

dowhile:    T_DO T_CA contsEstructura T_CC T_WHILE T_PA valores T_OPRELACION valores T_PC T_PTCOM{
             strcat($7,$8);strcat($7,$9);
            fprintf(fsalidaRep, "EstructuraRepetitiva:\tDo-while:\nCondicion de paro:\t%s\n========\n",$7);};

if:         T_IF T_PA valores T_OPRELACION valores T_PC T_CA contsEstructura T_CC {
            strcat($3,$4);strcat($3,$5);
            fprintf(fsalidaSel, "Condicional:\nif\nCondicion a evaluar:\t%s\n========\n",$3);}|
            T_IF T_PA valores T_OPRELACION valores T_PC contsEstructura    {
            strcat($3,$4);strcat($3,$5);
            fprintf(fsalidaSel, "Condicional:\nif\nCondicion a evaluar:\t%s\n========\n",$3);}|

            T_IF T_PA valores T_OPRELACION valores T_PC T_CA contsEstructura  {printf("\n\n Error en linea %d: Te falto cerrar la llave en el if. ", lineas);};

ifElse:     T_IF T_PA valores T_OPRELACION valores T_PC T_CA contsEstructura T_CC T_ELSE T_CA contsEstructura T_CC    {
            strcat($3,$4);strcat($3,$5);
            fprintf(fsalidaSel, "Condicional:\nif-else\nCondicion a evaluar:\t%s\n========\n",$3);};

switch:     T_SWITCH T_PA valores T_PC T_CA cases T_CC{
            fprintf(fsalidaSel, "Condicional:\nswitch-case\nCondicion a evaluar:\t%s\nCases: case %s \n========\n",$3,$6);};

cases:      cases case {strcat($1,", case");strcat($1,$2);$$=$1;}|
            case        {$$=$1;};

case:       T_CASE constantes T_DOSPTO operaciones T_BREAK T_PTCOM {$$=$2;}
            | T_CASE T_CAR T_DOSPTO operaciones T_BREAK T_PTCOM     {$$=$2;};

constantes: T_INT   {$$=$1;}|
            T_FLOAT {$$=$1;}|
            T_CHAR    {$$=$1;};

contsEstructura:   contsEstructura contEstructura|contEstructura| ;

contEstructura:      operaciones|estructuraAlgoritmo;

struct:             T_STRUCT T_ID T_CA declaracion T_CC T_PTCOM {
                    fprintf(fsalidaStru, "Struct:\t%s\nMiembros:\t%s\n========\n",$2,$4);};

%%

void yyerror(char *s){
    printf("\n\n %d: %s at %s\n", lineas, s, yytext);
    exit(0);
}        
int main(int argc, char **argv){
    if(argc>1){
        yyin = fopen(argv[1],"r");
        fsalidaRep = fopen("EstructuraRepetitiva.txt","w");
        fsalidaSel = fopen("EstructuraSelectiva.txt","w");
        fsalidaFun = fopen("Funciones.txt","w");
        fsalidaStru = fopen("Structs.txt", "w");
    }else{
        printf("Forma de uso: ./analizador archivo_entrada\n");
        return 0;
    }
    yyparse();
    return 0;
}





