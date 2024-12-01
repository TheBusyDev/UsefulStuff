@ECHO OFF

bash "courses.sh"

for /f %%c in (.course) do (
    if %%c==10 start msedge https://politecnicomilano.webex.com/meet/cristina.cerutti
    if %%c==11 start msedge https://politecnicomilano.webex.com/meet/norman.potrich
    if %%c==20 start msedge https://politecnicomilano.webex.com/meet/marco.moretti
    if %%c==21 start msedge https://politecnicomilano.webex.com/meet/guglielmopio.albani
    if %%c==30 start msedge https://politecnicomilano.webex.com/meet/fausto.distante
    if %%c==31 start msedge https://politecnicomilano.webex.com/meet/davide.roncelli
    if not %%c==0 timeout 15 & taskkill /F /IM msedge.exe
)