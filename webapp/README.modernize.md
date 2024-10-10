## Cosa da aggiustare con priorita

* p0 le 4 funzioni
* [P0] Le 4 demo, vedi sotto
* [P1] i 4 bottoni
* [P1] la app su CLoud Build, guarda perche non parte piu magari resuscitala a manhouse. Pribabile la colpa sia di PalmLLM
* [P3] per qualche motivo il
* [P4] Metti a posto il Tool in app/tool/

## Status

* ✅ **Demo1**. Funge ma il nuovo embedding non e' compatibile
    * Short solution: usa i vecchi (tipo 1) e non mostrare i tuoi 2-3 nuovi (tipo 3)
    * mid-long time version: ricalcola gli embedding on @004 e ricalcolali tutti.
* ⁉️ **Demo2**
* ⁉️ **Demo3**
* ✅ **Demo4** Smbra andare.

## Notule varie

* sembra che l'oggetto article sia molto brittle, ha un sacco di nil. Soluzioni
    * Crea filtro tipo Article.well_dones.where(...) dove il filtro well done verifica che i tuoi Article abbiano:
        - embedding corretti (basta averee le 3 embedding_xxx_description)
        - content non nullo
        - e cosi via.

## BUG
