    .data

input_addr:             .word  0x80
output_addr:            .word  0x84
sign_mask:              .word  0x80000000
sign_mask_for_neg:      .word  0x7FFFFFFF

    .text

    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

_start:
    @p input_addr a! @       \ загружаем входное значение
    
    check_sign_and_count

    @p output_addr a! !      \ вывод результата
    halt

    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

check_sign_and_count:
    dup                       
    @p sign_mask and         \ умножаем на маску, чтобы узнать есть ли знак
    lit 0 a!                 \ счётчик если число положительное
    if count_zeros           \ если знака нет, то переход
    @p sign_mask_for_neg and \ умножаем на маску, которая отсекает знаковый бит
    lit -1 a!                \ счётчик если число отрицательное

count_zeros:
    a                        \ загружаем счётчик нулей
    over
    lit 31 >r                \ создаём цикл

count_zeros_loop:
    dup
    lit 1 and                \ изолируем младший бит
    if bit_is_zero           \ если бит == 0, переходим к инкременту
    2/                       \ сдвигаем слово вправо на 1 бит
    next count_zeros_loop    \ повторяем цикл
    
bit_is_zero:
    over 
    lit 1 +                  \ прибавили к счётчику нулей
    over                     \ меняем местами счётчик и слово
    2/                       \ сдвигаем слово вправо
    next count_zeros_loop    \ повторяем цикл

finish:
    drop                    
    ;                        \ возвращаем счётчик (уже на стеке)
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\