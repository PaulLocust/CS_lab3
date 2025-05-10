    .data
input_addr:      .word  0x80               ; адрес, по которому находится входное значение n
output_addr:     .word  0x84               ; адрес, по которому нужно сохранить результат
buffer:          .word  0x0                ; переменная для временного хранения n
divides:         .word  0x2                ; делитель — число 2
one:             .word  0x1                ; просто единица (используется в формуле)
bad_result:      .word  -1                 ; результат при плохом вводе (если n <= 0)
bad_result_2:    .word  0xCCCCCCCC         ; результат при переполнении при вычислениях

    .text
_start:
    load_ind     input_addr                ; acc <- значение n (через косвенный доступ)
    store        buffer                    ; сохраняем n в буфер
    bgt          main                      ; если n > 0, переходим к основным вычислениям
    jmp          bad_input                 ; иначе — плохой ввод, переходим к обработке ошибки

main:
    load         buffer                    ; acc <- n
    add          one                       ; acc <- n + 1
    clv                                    ; сбрасываем флаг переполнения перед умножением
    mul          buffer                    ; acc <- (n + 1) * n
    div          divides                   ; acc <- ((n + 1) * n) / 2
    bvs          bad_end                   ; если переполнение — переходим в bad_end
    store_ind    output_addr               ; сохраняем результат по адресу output_addr
    jmp          end                       

bad_input:
    load         bad_result                ; загружаем значение -1
    store_ind    output_addr               ; сохраняем в выходной адрес — сигнал о плохом входе
    jmp          end

bad_end:
    load         bad_result_2              ; загружаем значение 0xCCCCCCCC
    store_ind    output_addr               ; сохраняем в выходной адрес — сигнал о переполнении
                                       
end:
    halt                                   ; завершение программы