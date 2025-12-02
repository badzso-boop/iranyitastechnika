# Irányítástechnika ZH Összefoglaló

Ez az összefoglaló a laboratóriumi fájlok (`.m` scriptek) elemzésén alapul, és a ZH-ra való felkészüléshez kulcsfontosságú témaköröket foglalja össze.

---

## 1. Rendszerek leírása és alapvető analízise (Labor 1, 2)

A rendszereket többféleképpen is leírhatjuk. Fontos, hogy ismerd a közöttük lévő átalakításokat és az egyes leírási módok jelentését.

- **Állapottér (State-Space):**
  - Mátrixokkal (`A, B, C, D`) írja le a rendszert.
  - MATLAB parancs: `ss(A, B, C, D)`r
  - **Stabilitás:** Az `A` mátrix sajátértékei (`eig(A)`) határozzák meg. Ha minden sajátérték valós része negatív, a rendszer stabil.

- **Átviteli függvény (Transfer Function):**
  - A kimenet és a bemenet Laplace-transzformáltjának aránya.
  - MATLAB parancs: `tf(szamlalo, nevezo)`
  - Formái:
    - Polinomiális: `tf([szaml_egyutthatok], [nev_egyutthatok])`
    - Időállandós: `tf(K, conv([T1, 1], [T2, 1]))`
    - Pólus-Zérus-Erősítés: `zpk(zerusok, polusok, erosites)`

- **Alapvető analízis parancsok:**
  - `pole()`: A rendszer pólusainak meghatározása (a nevező gyökei).
  - `zero()`: A rendszer zérusainak meghatározása (a számláló gyökei).
  - `dcgain()`: Statikus erősítés (a rendszer viselkedése `s=0`-n, azaz `t -> végtelen`).
  - `step()`: Egységugrás-válasz. Fontos jellemzői (`stepinfo` paranccsal):
    - `Overshoot`: Túllövés [%].
    - `SettlingTime`: Beállási idő.
    - `PeakTime`: Az első maximum helye.
  - `impulse()`: Impulzusválasz.
  - `bode()`: Bode-diagram (amplitúdó- és fázis-frekvencia karakterisztika).
  - `pzmap()`: Pólus-zérus térkép.

---

## 2. Szabályozási körök és analízisük (Labor 4, 5)

- **Nyitott kör (Open-Loop):** `Wo = Wc * Wp` (Szabályozó * Szakasz).
- **Zárt kör (Closed-Loop):** `Wry = feedback(Wo, 1, -1)` (Negatív egységnyi visszacsatolás).

- **Stabilitás a frekvenciatartományban (Bode-tétel):**
  - **Mindig a NYITOTT körön (`Wo`) vizsgáljuk!**
  - MATLAB parancs: `margin(Wo)`
  - **Fázistartalék (Phase Margin, Pm):** A fáziskarakterisztika távolsága a -180°-tól annál a frekvenciánál, ahol az erősítés `1` (0 dB). Ez a `wcp` vágási körfrekvencia.
    - **Jelentése:** Mennyire áll messze a rendszer a lengések határától. Nagyobb `Pm` -> kisebb túllövés, stabilabb viselkedés. (Pl. `Pm > 65°` egy tipikus követelmény).
  - **Erősítési tartalék (Gain Margin, Gm):** Az erősítés távolsága az `1`-től (0 dB) annál a frekvenciánál, ahol a fázis eléri a -180°-ot.
    - **Jelentése:** Megmutatja, mennyivel növelhetjük az erősítést, mielőtt a rendszer instabillá válna.
  - **Kritikus erősítés:** Ha a P-szabályozó erősítését `Ap = Gm`-re állítjuk, a zárt kör stabil-instabil határára kerül (oszcillálni fog).

---

## 3. Szabályozó típusok és tervezésük

A cél a zárt kör viselkedésének (stabilitás, sebesség, pontosság) javítása. A tervezés gyakran a szakasz (plant, `Wp`) pólusainak "kiejtésén" alapul.

- **P-szabályozó (Labor 4, 5):**
  - `Wc = Ap`
  - Növeli a rendszer gyorsaságát, de maradó hibát (`1-dcgain(Wry)`) eredményezhet 0-s típusú rendszereknél.

- **PI-szabályozó (Labor 6, 8):**
  - `Wc = Ap * (1 + 1/(Ti*s))`
  - **Célja:** A maradó hiba teljes eltüntetése (a `[1, 0]` a nevezőben, azaz az integrátor miatt).
  - **Tervezés (pólus-zérus ejtés):** Az integrálási időt (`Ti`) a szakasz leglassabb (legnagyobb) időállandójával tesszük egyenlővé, hogy kiessék a lassú pólus. `Wo = minreal(Wc * Wp)`.

- **Fázisjavító (Lead) szabályozó (Labor 7, 8):**
  - `Wc = Ap * (Td*s + 1) / (Tc*s + 1)` (ahol `Td > Tc`)
  - **Célja:** A fázistartalék (`Pm`) növelése, ezzel a túllövés csökkentése és a rendszer gyorsítása.
  - **Tervezés:** Gyakran a szakasz egy pólusának kiejtésére és egy `N` paraméter szerinti tervezési képletre épül.

- **PID-szabályozó (Labor 9, 10):**
  - Egyesíti a PI és a fázisjavító (deriváló) tag előnyeit.
  - **Tervezés:** Komplexebb, akár két pólus kiejtésére is épülhet (`T1`, `T2`).
  - **Optimalizálás (Labor 10):** A gyakorlatban az `Ap` erősítést gyakran úgy hangolják, hogy a zárt kör teljesítse a követelményeket (pl. `max overshoot < 5%`, `min Pm > 60°`), miközben egy célértéket (pl. beállási idő) minimalizálnak. Ehhez egy `for` ciklusban végigiterálnak lehetséges `Ap` értékeken.

---

## 4. Rendszer Típusa és Maradó Hiba

- **Rendszer típusa:** A nyitott kör `s=0`-n lévő pólusainak száma. Ezt a nevezőben lévő `[..., 0]` tagok mutatják.
- **0-s típusú rendszer:** Nincs integrátor a nyitott körben. Egységugrásra P-szabályozóval maradó hibája lesz. PI szabályozóval a hiba 0 lesz.
- **1-es típusú rendszer:** Egy integrátor van a nyitott körben. Már P-szabályozóval (vagy Lead-del) is 0 a maradó hibája egységugrásra.

---

## 5. Kiegészítő analízis (Labor 6, 8)

- **Beavatkozójel analízise (`Wru`):**
  - `Wru = feedback(Wc, Wp, -1)`
  - Megmutatja, mekkora jelet kell a szabályozónak kiadnia. `stepinfo(Wru).Peak` a maximális beavatkozójel értéke, ami fontos a fizikai korlátok miatt.

- **Zavaráselhárítás (`Wde`):**
  - `Wde = -feedback(Wp, Wc, -1)`
  - Megmutatja, hogy a rendszer kimeneténél megjelenő zavarás (`d`) hogyan hat a hibajelre (`e`). Cél, hogy a zavarás hatása minél kisebb legyen.

---

## 6. Digitális szabályozás (Labor 12)

A folytonos szabályozót (`Wc`) a gyakorlatban digitálisan valósítjuk meg.

- **Diszkretizálás:**
  - MATLAB parancs: `Dc = c2d(Wc, Ts, 'modszer')`, ahol `Ts` a mintavételezési idő.
  - Leggyakoribb módszer: `'zoh'` (Zero-Order Hold).
- **Mintavételezési idő (`Ts`) megválasztása:**
  - Kulcsfontosságú! Túl nagy `Ts` rontja a stabilitást (csökkenti a fázistartalékot).
  - **Ökölszabály:** A nyitott kör vágási körfrekvenciájából (`wcp`) számolható egy maximális `TsMax`. A választott `Ts`-nek ennél lényegesen kisebbnek kell lennie.
  - A fázisromlás mértéke: `romlas_fokban = (wcp * Ts) / 2 * (180/pi)`.
- **Eredmény:** A diszkretizált szabályozó egy differenciaegyenlet, ami leírja, hogyan kell a bemenő hibajel (`e[k]`) mintáiból kiszámolni a kimenő beavatkozójel (`u[k]`) mintáit. (Pl. `u[k] = u[k-1] + a*e[k] - b*e[k-1]`).
