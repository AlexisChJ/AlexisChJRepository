#lang racket
;ALEXIS CHAVEZ JUAREZ A01657486
;BRUNO CONTRERAS SILVA A01657766
;ANDRES TAVERA MIHAILIDE A01657332
;DIEGO ROQUE DE ROSAS A01657709

;Importacion de paquetes
(require racket/port)
(require "myLexer.rkt" parser-tools/lex)

; Función que escribirá en un nuevo archivo txt y se considera el salto de linea
(define (write-to-a-file-new-line path txt)
  (call-with-output-file path
    (lambda (output-port)
      (writeln txt output-port))
    #:exists 'append))

; Función que escribe en un archivo recibiendo el texto y el path
(define (write-to-a-file path txt)
  (call-with-output-file path
    (lambda (output-port)
      (print txt output-port))
    #:exists 'append))

; Función que crea un archivo en el path establecido 
(define (create-file path)
  (define out (open-output-file path))
  (close-output-port out))

; Función que evalúa si analiza con base el lexer el archivo txt recibido como input y prepara el output en el archivo de salida para la consola de html
(define (processingSintaxer inputFile)
  (if (file-exists? "myOutput.txt")
      (delete-file "myOutput.txt")
      (create-file "myOutput.txt"))
  (printf "Token    Tipo\n")
  (write-to-a-file-new-line "myOutput.txt" "Token    Tipo")
  (port-count-lines! inputFile)
  (let ([token-count 0]
        [error-found #f]
        [error-messages '()])
    (letrec ([one-line 
              (lambda ()
                (let ([result (lexerAritmetico inputFile)])
                  (unless (equal? result 'EOF)
                    (set! token-count (+ token-count 1))
                    (printf "~a    |     " (token-value result))
                    (printf "~a\n" (token-name result))
                    (printf "\n")
                    (write-to-a-file "myOutput.txt" (token-value result))
                    (write-to-a-file "myOutput.txt" "      |     ")
                    (if (equal? (token-name result) 'ERROR)
                        (begin
                          (write-to-a-file "myOutput.txt" 'Error_de_sintaxis)
                          (set! error-found #t)
                          (set! error-messages (cons (format "Error en el caracter: ~a" (token-value result)) error-messages)))
                        (write-to-a-file "myOutput.txt" (token-name result)))
                    (write-to-a-file-new-line "myOutput.txt" "")
                    (one-line))))])
      (one-line))
    (if error-found
        (begin
          (write-to-a-file-new-line "myOutput.txt" "Lexico con errores sintacticos")
          (cons "Lexico con errores sintacticos" (reverse error-messages)))
        (begin
          (write-to-a-file-new-line "myOutput.txt" "Lexico sin errores sintacticos")
          '("Lexico sin errores sintacticos")))))

; Función que recibe el archivo de entrada y lo envia al analizador del lexer
(define (mySintaxer inputFile)
  (processingSintaxer (open-input-string inputFile)))

; Función para colorear los tokens en el archivo HTML dependiendo de las categorias
(define (colorize-token token)
  (let ([token-value (token-value token)]
        [token-name (token-name token)])
    (cond
      [(memv token-name '(SUMA RESTA MULTIPLICACION DIVISION POTENCIA DIVISION_ENTERA_Y_ASIGNACION
                               SUMA_Y_ASIGNACION RESTA_Y_ASIGNACION MULTIPLICACION_Y_ASIGNACION DIVISION_Y_ASIGNACION POTENCIA_Y_ASIGNACION
                               MODULO_Y_ASIGNACION MODULO DIVISION_ENTERA))
       (format "<span style=\"color:green;\">~a</span>" token-value)]
      [(memv token-name '(ENTERO REAL INT FLOAT BOOL STR BYTES COMPLEX BYTEARRAY DICT FROZENSET LIST SET TUPLE GLOBAL))
       (format "<span style=\"color:orange;\">~a</span>" token-value)]
      [(memv token-name '(PARENTESISABRE PARENTESISCIERRA LLAVEABRE LLAVECIERRA BRACKETCIERRA BRACKETABRE INTERROGACIONCIERRA MARCADOR_DE_VARIABLE INTERROGACIONABRE EXCLAMACIONABRE EXCLAMACIONCIERRA))
       (format "<span style=\"color:gray;\">~a</span>" token-value)]
      [(memv token-name '(SIMPLECOMILLA DOBLECOMILLA DOS_PUNTOS COMA PUNTO))
       (format "<span style=\"color:purple;\">~a</span>" token-value)]
      [(eq? token-name 'VARIABLE)
       (format "<span style=\"color:black;\">~a</span>" token-value)]
      [(eq? token-name '(AND OR NOT SIGNO_AND SIGNO_OR SIGNO_XOR IGUAL_A NO_ES_IGUAL_A MAYOR_QUE MENOR_QUE MAYOR_O_IGUAL_A MENOR_O_IGUAL_A))
       (format "<span style=\"color:silver;\">~a</span>" token-value)]
      [(eq? token-name 'ASIGNACION)
       (format "<span style=\"color:aqua;\">~a</span>" token-value)]
      [(eq? token-name 'COMENTARIO)
       (format "<span style=\"color:navy;\">~a</span>" token-value)]
      [(memv token-name '(ERROR))
       (format "<span style=\"color:white; background-color:red;\">~a</span>" token-value)]
      [(memv token-name '(TRUE FALSE NONE IF WHILE ELIF ELSE EXCEPT FOR))
       (format "<span style=\"color:blue;\">~a</span>" token-value)]
      [(memv token-name '( IMPORT IN IS LAMBDA NONLOCAL PASS RAISE SELF RANGE RETURN TRY WITH YIELD AS
                                  ASSERT ASYNC AWAIT BREAK CLASS DEF DEL CONTINUE FROM FINALLY ITEMS KEYS INSERT INDEX HEX ID STRIP SUPER
                                  LOWER JOIN TITLE SWAPCASE LSTRIP UPPER POP VALUES ZFILL POPITEM OPEN PRINT INPUT REPLACE RSPLIT SPLIT LEN
                                  ENUM GET FORMAT_MAP FORMAT SLICE PROPERTY STARTSWITH HASATTR GETATTR INIT MAIN NAME DOC FILE DICT))
       (format "<span style=\"color:fuchsia;\">~a</span>" token-value)]
      [else
       (format "~a" token-value)])))

; Función que crea un archivo HTML con el contenido de input.txt y tokens coloreados con las condiciones anteriores
(define (create-html-file input-path output-path)
  (define input-contents (port->string (open-input-file input-path) #:close? #t))
  (define html-content "")
  (define input-port (open-input-string input-contents))
  (port-count-lines! input-port)
  
  (letrec ([one-line
            (lambda ()
              (let ([result (lexerAritmetico input-port)])
                (cond
                  [(equal? result 'EOF)]
                  [(eq? (token-name result) 'newline)
                   (set! html-content (string-append html-content "<br>\n"))]
                  [else
                   (set! html-content (string-append html-content (colorize-token result) " "))])
                (when (not (equal? result 'EOF))
                  (one-line))))])
    (one-line))
  
  ; Evaluar el archivo de entrada y determinar si es léxicamente correcto y la consola para el final del html
  (define lexico-status (processingSintaxer (open-input-string input-contents)))

  (call-with-output-file output-path
    (lambda (output-port)
      (fprintf output-port "<!DOCTYPE html>\n")
      (fprintf output-port "<html>\n<head>\n<title>Input File</title>\n</head>\n<body>\n<pre>\n")
      (fprintf output-port "~a\n" html-content)
      (fprintf output-port "</pre>\n")
      (fprintf output-port "<div style='background-color: black; color: white; padding: 10px;'><pre>\n")
      (fprintf output-port "Consola:\n")
      (for-each (lambda (msg) (fprintf output-port "~a\n" msg)) lexico-status)
      (fprintf output-port "</pre></div>\n")
      (fprintf output-port "</body>\n</html>\n"))
    #:exists 'replace))

; Se le aplica un provide para poder usarlo desde cualquier parte (exportarlo)
(provide mySintaxer value-tokens op-tokens lexerAritmetico create-html-file)

; Función que recibe input-contents en un path especifico
(define input-contents
  (port->string (open-input-file "input.txt") #:close? #t))

; Se manda llamar a input-contents
(mySintaxer input-contents)

; Crear archivo HTML a partir del input.txt
(create-html-file "input.txt" "output.html")

(time (mySintaxer input-contents))
