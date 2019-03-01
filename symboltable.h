#include<stdio.h>
#include<string.h>
#include<stdlib.h>
typedef struct st_rec
{
    char *tk_name;
    union
    {
        int int_val;
        float float_val;
        char* string_val;
    } value;
    struct st_rec *next;
} st_rec;

void init_table()
{
    symbol_table[0] = (symrec*)malloc(sizeof(symrec));
    symbol_table[0]->tk_name = (char*)malloc(6*sizeof(char));
    strcpy(symbol_table[0]->tk_name, "START");
    symbol_table[0]->value = 0;
    symbol_table[0]->next = NULL;
}

void init_line(int ln)
{
    symbol_table[ln] = (st_rec*)malloc(sizeof(st_rec));
    symbol_table[ln]->value = 0;
    symbol_table[ln]->next = NULL;
}

st_rec* chain_sym(int ln)
{
    st_rec *ptr = symbol_table[ln];
    if(ptr == NULL)
    {
        init_line(ln);
        symbol_table[0]->tk_name = (char*)malloc(12*sizeof(char));
        strcpy(symbol_table[0]->tk_name, "STARTLINE");
    }
    while(ptr->next != NULL)
    {
        ptr = ptr->next;
    }
    return ptr;
}
st_rec* putsym(char const* tk_name, int lineno)
{
    st_rec *prev = chain_sym(lineno);
    st_rec* ptr = (st_rec*)malloc(sizeof(st_rec));
    ptr->tk_name = (char*)mallo(strlen(tk_name+1)*sizeof(char));
    strcpy(ptr->tk_name, tk_name);
    ptr->value = 0;
    prev->next = ptr;
}

st_rec* getsym(char const* tk_name, int ln) //Try to get  lineno
{
    for(i=0; i<ln; i++)
    {
        st_rec *ptr = symbol_table[i];
        while(ptr!=NULL)
        {
            ptr  = ptr->next;
            if(strcmp(ptr->tk_name, tk_name)==0)
                return ptr;
        }
    }
    if(i == ln)
    {
        st_rec *ptr = putsym(tk_name, ln);
    }    
    return ptr;
}