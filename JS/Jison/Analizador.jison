%{
let  contadorVariablesTemporales = 0;

function evalularTemporal(expresion){
    /*Si la expresión ya fue asignada a un temporal devuelve el temporal,
    si no entonces devuelve la expresión*/
    return expresion.temporal != '' ?  expresion.temporal :  expresion.valor;
}

%}

/* Análisis Léxico */
%lex
%%

\s+                   /* omitir espacios en blanco whitespace */
([a-zA-Z])[a-zA-Z0-9_]*          return 'id'
[0-9]+("."[0-9]+)?\b             return 'numeros'
"*"                              return '*'
"/"                              return '/'
"-"                              return '-'
"+"                              return '+'
"^"                              return '^'
"("                              return '('
")"                              return ')'
<<EOF>>                          return 'EOF'
.                                return 'INVALID'

/lex

/* Precedencia y asociatividad */

%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS

%start PRODUCCION_INICIAL

%% /* Gramática */

PRODUCCION_INICIAL
    : EXPRESIONES EOF{
         contadorVariablesTemporales = 0; //se reinicia el contador para próximos análisis
         return $1.c3d;
    }
;

EXPRESIONES
    : EXPRESIONES '+' EXPRESIONES{
        contadorVariablesTemporales++;
        $$ = {
            valor: $1.valor +  $3.valor,
            c3d :  $1.c3d + $3.c3d + 't'+ contadorVariablesTemporales + ' = ' + evalularTemporal($1) + $2 + evalularTemporal($3) + '\n',
            temporal: 't'+ contadorVariablesTemporales
        };
    }
    | EXPRESIONES '-' EXPRESIONES{
        contadorVariablesTemporales++;
        $$ = {
            valor: isNaN($1.valor) || isNaN($3.valor) ? String($1.valor) + $2.valor + String($3.valor) : $1.valor - $3.valor,
            c3d :  $1.c3d + $3.c3d + 't'+ contadorVariablesTemporales + ' = ' + evalularTemporal($1) + $2 + evalularTemporal($3) + '\n',
            temporal: 't'+ contadorVariablesTemporales
        };
    }
    | EXPRESIONES '*' EXPRESIONES{
        contadorVariablesTemporales++;
        $$ = {
            valor: isNaN($1.valor) || isNaN($3.valor) ? String($1.valor) + $2.valor + String($3.valor) : $1.valor * $3.valor ,
            c3d :  $1.c3d + $3.c3d + 't'+ contadorVariablesTemporales + ' = ' + evalularTemporal($1) + $2 + evalularTemporal($3) + '\n',
            temporal: 't'+ contadorVariablesTemporales
        };
    }
    | EXPRESIONES '/' EXPRESIONES{
        contadorVariablesTemporales++;
        $$ = {
            valor: isNaN($1.valor) || isNaN($3.valor) ? String($1.valor) + $2.valor + String($3.valor) : $1.valor / $3.valor ,
            c3d :  $1.c3d + $3.c3d + 't'+ contadorVariablesTemporales + ' = ' + evalularTemporal($1) + $2 + evalularTemporal($3) + '\n',
            temporal: 't'+ contadorVariablesTemporales
        };
    }
    | EXPRESIONES '^' EXPRESIONES{
        contadorVariablesTemporales++;
        $$ = {
            valor: isNaN($1.valor) || isNaN($3.valor) ? String($1.valor) + $2.valor + String($3.valor) : Math.pow($1.valor, $3.valor),
            c3d :  $1.c3d + $3.c3d + 't'+ contadorVariablesTemporales + ' = ' + evalularTemporal($1) + $2 + evalularTemporal($3) + '\n',
            temporal: 't'+ contadorVariablesTemporales
        };
    }
    | '-' EXPRESIONES %prec UMINUS{
        contadorVariablesTemporales++;
        $$ = {
            valor: $2.valor * -1,
            c3d :  $2.c3d + 't'+ contadorVariablesTemporales + ' = ' + $1 + $2.valor + '\n',
            temporal: 't'+ contadorVariablesTemporales
        };
    }
    | '(' EXPRESIONES ')'{
        $$ = {
            valor: $2.valor,
            c3d : $2.c3d,
            temporal: $2.temporal
        };
    }
    | numeros{
        $$ = {
            valor: Number($1),
            c3d : "",
            temporal: ''
        };
    }
    | id{
        $$ = {
            valor: $1,
            c3d : "",
            temporal: ''
        };
    }
;
