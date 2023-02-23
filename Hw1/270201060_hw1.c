//Talha Arık 270201060
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct dynamic_array {
    int capacity;
    int size;
    void** elements;
} dynamic_array;

void init_array(dynamic_array* array) {
    array->capacity = 2;
    array->size = 0;
    array->elements = malloc(sizeof(void*) * array->capacity);
    for(int i=0; i<array->capacity; i++)
    {
        array->elements[i] = NULL;
    }
}


void put_element(dynamic_array* array, void* element) {
    array->elements[array->size++] = element;
    if(array->size == array->capacity){
        array->capacity *= 2;
        array->elements = realloc(array->elements, array->capacity * sizeof(void*));
        for(int i = array->size; i < array->capacity; i++) {
            array->elements[i] = NULL;
        }
    }
}


void remove_element(dynamic_array* array, int position) {
    //song* s = array->elements[position];
    free(array->elements[position]);
    array->elements[position] = NULL;
    if(array->size != position) {
        for(int i = position; i < array->size-1; i++) {
            array->elements[i] = array->elements[i - 1];
        }
    }
    array->size--;
    if(array->size <= array->capacity/2) {
        array->elements = realloc(array->elements, array->capacity/2 * sizeof(void*));
    }
    array->capacity /= 2;
}


void* get_element(dynamic_array* array, int position) {
    if(position > array->capacity -1) return NULL;
    return array->elements[position];
}

typedef struct song {
    char* name;
    float duration;
}song;


int main() {
    int input = -1;
    dynamic_array dArr;
    init_array(&dArr);

    while(input <= 3)
    {
        printf("1-Add Song\n2-Remove Song \n3-List All\n");
        scanf("%d", &input);
        if(input == 1){
            char* name = malloc(64 * sizeof(char));
            float duration = 0;
            printf("Type Name of Song: ");
            scanf("%s", name);
            printf("Type Duration of Song: ");
            scanf("%f", &duration);
            song* s = (song*) malloc(sizeof(song));
            s->name = name;
            s->duration = duration;

            put_element(&dArr, s);
        }
        else if(input == 2){
            char name[64];
            float duration;
            printf("song name: ");
            scanf("%s", name);
            printf("\n");
            printf("duration: ");
            scanf("%f", &duration);
            for(int i = 0; i<dArr.size; i++) {
                if(((song*)dArr.elements[i])->duration == duration && strcmp(((song*)dArr.elements[i])->name, name) == 0){
                    song* song1 = (song*)dArr.elements[i];
                    remove_element(&dArr, i);
                    //free(song1);
                }
            }
        }
        else if(input == 3){
            for(int i=0; i<dArr.size; i++)
            {
                printf("%s, %f\n",((song*)get_element(&dArr, i))->name, ((song*)get_element(&dArr, i))->duration);
            }
        }
        else {
        }
    }
    return 0;
}