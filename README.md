## When you have the data-variable in a function argument 

```
# (i.e. an env-variable that holds a promise2), you need 
# to embrace the argument by surrounding it in doubled braces, 
# like filter(df, {{ var }}).
# See vignette("programming", package = "dplyr") and Advance R

extract_refnum <- function(df, var) {
  df |>
    mutate(refnum = str_extract({{ var }}, "\\d{6}\\:")) |>
    mutate(refnum = str_replace(refnum, ":", "")) |>
    select(refnum, colnames(df))
}
```
