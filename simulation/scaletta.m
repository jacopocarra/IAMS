

%{
INTRO
buongiorno in questa presentazione vogliamo illustrarvi alcune strategie di trasfermento da noi ideate per passare da un punto dato in un'orbita iniziale
ad un altro su un un'orbita finale

ORBI INIZ
Il punto sull'orbita iniziale è individuato da i vettori posizione e velocità che abbiamo convertito nei sei parametri orbitali.
Tale orbita si colloca al limite inferiore della categoria MEO, presenta una bassa eccentricità e un'inclinazione media

ORB FIN
Il punto sull'orbita finale invece era caratterizzato dai sei paramentri orbitali che abbiamo convertito nei vettori posizione e velocità.
Essa è una MEO polare con semiasse maggiore ed eccentricità  maggiori dell'orbita  iniziale.

STRAT 1 pa (CAMBIARE VIDEO)
Questa strategia si basa su manovre standard, la prima delle quali è un cambio di piano effettuato nel punto a quota maggiore tra i due possibili in modo
da ridurne il costo.
Segue un cambio di anomalia del pericentro per allinearla a quella finale ed infine una manovra bitangente dal pericentro attuale all'apocentro dell'orbita
obiettivo.

STRAT 1 ap 
E' possibile effettuare un trasferimento analogo salvo per l'ultima manovra che risulta essere una bitangente dall'apocentro dell'orbita attuale al 
pericentro dei quella finale

CONFRONTO
sono state calcolate altre due varianti, ovvero quelle per cui la bitangente viene eseguita tra i due apocentri o tra i due pericentri.
Tali manovre, richiedendo uno sfasamento di 180 gradi tra l'orbita precedente a quella di trasferimento bitangente e quella finale, risultano essere piu
dispendiose in termini di deltaV. Invece la PA e AP sono simili in termini di deltaV, con la AP che ha un deltaT inferiore di un'ora e mezzo


STRAT 2
Abbiamo notato che cambiando l'ordine delle manovre è possibile ridurre il costo del trasferimento effettuando il cambio di piano in un punto piu lontano.
Infatti come prima maonovra effettuiamo la bitangente dal pericentro dell'orbita iniziale per ottenere un orbita con una forma uguale a quella finale.
A questo punto eseguiamo il cambio di piano nel punto con quota maggiore fra i due possibili ed infine allineaiamo l'orbita a quella finale cambiando 
l'anomalia di pericentro

STRAT 3
La strategia 3 prevede un trasferimento diretto fra il punto iniziale e quello finale sfruttando due manovre non standard che consentono di immettersi 
nell'orbita di trasferimento e poi in quella finale.
Per determinare l'orbita di trasferimento abbiamo proceduto come segue: 
	abbiamo determinato il piano dell'orbita come passante per i due punti dati e per il fuoco, calcolando effettivamente inclinazione e RAAN
	abbiamo poi, fissato un fuoco e due punti di passaggio in un piano, esistono infinite coniche, pertanto abbiamo imposto i vincoli di non intersezione con la terra
	 nell'arco percorso e di orbita chiusa. A questo punto, iterando sui valori dell'anomalia di pericentro (da 0 a 360) , abbiamo definito di volta in
	 volta una possibile orbita di trasferimento e selezionato alla fine quella che garantisce il deltaV minore.
Abbiamo notato che per alcuni valori di omega, l'eccentricità dell'orbita di trasferimento risulta negativa. Ciò significa che il vettore eccentricità
in questi casi punta all'apocentro, ed omega (piccolo) risulta l'angolo tra il nodo ascendente e apocentro in disaccordo con le nostre definizioni di 
parametri orbitali. Tali orbite equivalgono ad orbite con eccentricità positiva, omega (piccolo) ed anomalia vera sfasate di 180 gradi rispetto a quelli
calcolati ricadento pertanto nei casi analizzati nella seconda metà di grafico.


STRAT 4
La strategia 4 prevede un cambio di piano durante un trasferimento biellittico.
Prevede un primo cambio di anomalia di pericentro, seguito da una manovra tangente verso un raggio di apocentro di 500000km.
Viene eseguito un cambio di piano che, grazie al cambio di pericentro, avviene in prossimità dell'apocentro riducendone il costo. Giunti all'
apocentro dell'orbita corrente si esegue una bitangente verso il pericentro dell'orbita obiettivo. Un secondo cambio di anomalia di pericentro 
permette di raggiungere l'orbita finale.
Il valore di 289.5° è stato scelto minimizzando il costo del deltaV complessivo del trasferimento. Infatti per fare il cambio di piano vicino all'apocentro,
è necessario ruotare l'orbita iniziale cambiando la sua anomalia di pericentro. Questo però introduce un ulteriore deltaV. Quindi abbiamo cercato di 
ottimizzare il trasferimento, attraverso un processo iterativo, trovando l'omega che minimizzi il deltaV totale.
Per quanto riguarda la scelta del raggio di allontanamento è un compromesso tra la riduzione di deltaV totale che abbiamo aumentandolo e l'aumento 
del tempo di trasferimento totale, come si può vedere dal grafico.





STRAT 5a
-cambio di anomalia per iniziale sostitutito con circolarizzazione che riulta poco costosa vista la  bassa eccentricità dell'orbita.
-manovra tangente sulla retta di intersezaione tra il piano orbitale iniziale e quello finale in modo da immettersi in un'orbita elllittica
che abbia l'apocentro nel punto di cambio di piano. Il raggio di apocentro di quest'orbita sarà uguale al raggio di apocentro dell'orbita
finale
-raggiunto l'apocentro viene eseguito il cambio di piano e la circolarizzazione dell'orbita
-Infine viene eseguita una manovra tangente in corrispondenza dell'apocentro dell'orbita finale in modo da immettersi nell'orbita obiettivo

-la linea di intersezione dei piani viene calcolata come prodotto vettore tra i momenti della quantità di moto delle due obite.
 essendo un'orbita circolare, l'anomalia vera su cui manovrare è calcolata come angolo fra il nodo ascendente dell'orbita circolare e questa retta, viene
 scelta la posizione piu vicina a quella in cui ci si trova

Strat 5b

è una variante della 5a, dove il raggio di allontanamento dell'orbita ellittica risulta uguale a quello di pericentro dell'orbita finale.
Eseguito il cambio di piano e la seconda circolarizzazione, si dovrà eseguire una manovra tangente in corrispondenza del pericentro dell'orbita finale in 
modo da immetttersi effettivamente nell'orbita obiettivo


STRAT 6:
Questa strategia unisce i pregi delle strategie 4 e 5.
Come nella strategia 5, si circolarizza all'apocentro e si esegue una manovra tangente in modo da far coincidere l'apocentro dell'orbita ellittica di trasferimento 
con il punto in cui è possibile cambiare il piano. In corrispondenza di questo punto si esegue, insieme al cambio di pinao anche una manovra tangente che serve a far 
coincidere il raggio di pericentro di questa orbita con il raggio di pericentro dell'orbita finale. In questo punto di intersezione si esegue una manovra tangente per
ottenere un'orbita con la forma dell'orbita finale. Infine si esegue un cambio di anomalia del pericentro per allinearla con l'orbita finale.

Essa unisce la scelta dell'allontanamento per il cambio di piano biellittico della 4 e l'uso della prima circolarizzazione e della doppia manovra esattamente 
all'apocentro della 5.
%}
A = 'loool'