*"* use this source file for any type declarations (class
*"* definitions, interfaces or data types) you need for method
*"* implementation or private method's signature

types: begin of ty_idx,
         name type zguidrasil_container_name,
         control_id type n length 3,
       end of ty_idx,
       ty_idx_t type SORTED TABLE OF ty_idx WITH UNIQUE key name.
