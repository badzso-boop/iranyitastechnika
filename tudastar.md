# 📚 Tudástár (Cheat Sheet) a ZH-hoz

Ezeket érdemes fejben tartanod a feladatok megoldásához és a kézi számoláshoz:

#### 1. Szabályozók Átviteli Függvényei (Folytonos)
*   **PI szabályozó:**
    $$W_c(s) = A_p \left(1 + \frac{1}{sT_i}\right) = A_p \frac{1+sT_i}{sT_i}$$
    *   *Póluskiejtés:* $T_i$ legyen egyenlő a szakasz **leglassabb** (legnagyobb időállandójú) pólusának időállandójával.
    * Matlab parancsban: 
    ```MATLAB
    Ap = 0.035
    Ti = 5
    Wc = Ap/Ti * tf([Ti, 1], [1, 0])
    ```
*   **PD szabályozó (Valós/Szűrős):**
    $$W_c(s) = A_p \left(1 + \frac{sT_d}{1+sT_c}\right)$$
    *   *Póluskiejtés:* $T_d$ ejtse ki a szakasz megfelelő (általában második leglassabb) pólusát.
    *   *Szűrő:* Általában $T_c = \frac{T_d}{10}$ (ha $N=10$). 
*   **PID szabályozó:**
    $$W_c(s) = A_p \left(1 + \frac{1}{sT_i} + sT_d\right)$$
    *   *Alkalmazás:* Ha pontos (integráló) és gyors (differenciáló) szabályozás is kell.
    *   *Póluskiejtés:* $T_i$ a leglassabb, $T_d$ a második leglassabb időállandót ejtheti ki.

#### 2. Minőségi Jellemzők (Bode & Ugrásválasz)
*   **Stabilitás**
    * Akkor stabil ha minden valós rész negatív
    * parancs amivel elérhető: `pole(Wp)`
*   **Statikus erősítés**
    * Akkor kapjuk meg ha az egyenletben az s-t 0-val tesszük egyenlővé:
    * paranccsal: `dcgain(Wp)`
*   **Fázistartalék ($PM, \varphi_t$):**
    Megmutatja, mennyire stabil a rendszer.
    *   Kiszámítása: $PM = 180^\circ + \varphi(\omega_c)$, ahol $\omega_c$ a vágási körfrekvencia ($|L(j\omega)|=1$). 
    *   *Összefüggés:* Nagyobb PM $\to$ Kisebb túllövés, de lassabb működés. (60° általában ideális).
*   **Erősítési tartalék ($GM$):**
    Mennyivel szorozható meg az erősítés, mielőtt a rendszer instabillá válik.
    *   Ott mérjük, ahol a fázis $-180^\circ$.
*   **Maradó hiba ($e_{err}$):**
    *   **0-s típusú rendszer (Nincs integrátor, pl. P szabályozó):** Van maradó hiba. $e = \frac{1}{1+K_{hurok}}$.
    *   **1-es típusú rendszer (Van 1 integrátor, pl. PI szabályozó):** Egységugrásra a hiba 0.

#### 3. Diszkretizálás (Mintavételi idő)
Ha a feladat a fázistartalék romlását korlátozza ($\Delta\varphi_{max}$), a mintavételi idő ($T_s$) közelítő számítása:

$$ \Delta\varphi \approx \frac{\omega_c \cdot T_s}{2} \cdot \frac{180}{\pi} $$

Ebből a maximális $T_s$:
$$ T_s \le \frac{2 \cdot \Delta\varphi_{max} \cdot \pi}{180 \cdot \omega_c} $$
*(Figyelj rá, hogy a $\Delta\varphi$ fokban van megadva, át kell váltani radiánba, vagy a 180-as váltószámmal korrigálni!)*

#### 4. Differenciaegyenletek (Kézi felíráshoz, Euler backward)
A szabályozó $u[k]$ kimenetének számítása a $e[k]$ hibajelből.
Helyettesítés: $s \approx \frac{1-z^{-1}}{T_s}$

*   **PI Szabályozó:**
    $$ u[k] = u[k-1] + A_p \left(1 + \frac{T_s}{T_i}\right)e[k] - A_p e[k-1] $$

*   **PID Szabályozó (D tagon szűrő nélkül):**
    $$ u[k] = u[k-1] + q_0 e[k] + q_1 e[k-1] + q_2 e[k-2] $$
    Ahol az együtthatók:
    $$ q_0 = A_p \left(1 + \frac{T_s}{T_i} + \frac{T_d}{T_s}\right) $$
    $$ q_1 = -A_p \left(1 + 2\frac{T_d}{T_s}\right) $$
    $$ q_2 = A_p \frac{T_d}{T_s} $$