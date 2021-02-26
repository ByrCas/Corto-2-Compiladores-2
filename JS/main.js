
//#region Editores

let editorEntrada = CodeMirror.fromTextArea(document.getElementById('lectorEntrada'), {
    mode: "javascript",
    theme: "rubyblue",
    lineNumbers: true,
    readOnly: false 
});

let editorSalida = CodeMirror.fromTextArea(document.getElementById('visorSalida'), {
    mode: "javascript",
    theme: "cobalt",
    lineNumbers: true,
    readOnly: true 
});

//#endregion Editores

//#region Analizador

//#region Entrada
let entrada_0 =  '(a + b) * (a + c)';
let entrada_1 =  'x * x';
let entrada_2 =  'y * y';
let entrada_3 =  'x2 + y2';
let entrada_4 =  'b + c + d';
let entrada_5 =  'a * a + b * b';
let entrada_6 =  '5 + 2 * b';
let entrada_7 =  '6 + 7 * 10+5 / 1';
let entrada_8 =  '((7 + 9)/(((3 + 1) * (6 + 7) + 8) * 7) / 9) + 100';
let entrada_9 = '7 * 9 - 89 + 63';
let entradaSeleccionada;

//#endregion Entrada

let botonEjecucion = document.getElementById('botonEjecucion');
botonEjecucion.addEventListener("click", ejecutarAnalisis);
botonEjecucion.disabled = true;
document.getElementById('selectorOpciones').addEventListener("change", obtenerOpcionSeleccionada);


function obtenerOpcionSeleccionada(){
    let indicadorOpcion = document.getElementById('selectorOpciones').value;
    indicadorOpcion = indicadorOpcion.charAt(indicadorOpcion.length-1);
    eval( "entradaSeleccionada = entrada_" + indicadorOpcion );
    editorEntrada.setValue(entradaSeleccionada);
    botonEjecucion.disabled = false;
}

function ejecutarAnalisis(){
    
}

//#endregion Analizador