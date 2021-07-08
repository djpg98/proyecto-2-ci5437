library(ggplot2)
setwd("./Results")
NM <- read.csv("./negamax_results.csv", header=TRUE)
NMAB <- read.csv("./negamax_ab_results.csv", header=TRUE)
SCOUT <- read.csv("./scout_test_results_1.csv", header=TRUE)
NSCOUT <- read.csv("./negascout_results_1.csv", header=TRUE)


#Averages table
solved<- c(length(NM$npv), length(NMAB$npv), length(SCOUT$npv), length(NSCOUT$npv))
expanded <- c(mean(NM$expanded.nodes), mean(NMAB$expanded.nodes), mean(SCOUT$expanded.nodes), mean(NSCOUT$expanded.nodes))
generated <- c(mean(NM$generated.nodes), mean(NMAB$generated.nodes), mean(SCOUT$generated.nodes), mean(NSCOUT$generated.nodes))
seconds <- c(mean(NM$seconds), mean(NMAB$seconds), mean(SCOUT$seconds), mean(NSCOUT$seconds))
rates <- c(mean(NM$generated.seconds[NM$generated.seconds!=Inf]),
           mean(NMAB$generated.seconds[NMAB$generated.seconds!=Inf]),
           mean(SCOUT$generated.seconds[SCOUT$generated.seconds!=Inf]),
           mean(NSCOUT$generated.seconds[NSCOUT$generated.seconds!=Inf])
)
avgdf <- data.frame(Algorithm = c("Negamax", "Negamax (w\ alpha-beta)", "Scout", "Negascout"),
                    Solved=solved,
                    Expanded=expanded,
                    Generated=generated,
                    Seconds=seconds,
                    Rate=rates
                    )
write.csv(avgdf, "./AvgTable.csv", row.names = TRUE)

#AHORA SOLO LOS PRIMEROS 20
SCOUT20 <- head(SCOUT, 20)
NSCOUT20 <- head(NSCOUT, 20)

#Averages table
solved<- c(length(NM$npv), length(NMAB$npv), length(SCOUT20$npv), length(NSCOUT20$npv))
expanded <- c(mean(NM$expanded.nodes), mean(NMAB$expanded.nodes), mean(SCOUT20$expanded.nodes), mean(NSCOUT20$expanded.nodes))
generated <- c(mean(NM$generated.nodes), mean(NMAB$generated.nodes), mean(SCOUT20$generated.nodes), mean(NSCOUT20$generated.nodes))
seconds <- c(mean(NM$seconds), mean(NMAB$seconds), mean(SCOUT20$seconds), mean(NSCOUT20$seconds))
rates <- c(mean(NM$generated.seconds[NM$generated.seconds!=Inf]),
           mean(NMAB$generated.seconds[NMAB$generated.seconds!=Inf]),
           mean(SCOUT20$generated.seconds[SCOUT20$generated.seconds!=Inf]),
           mean(NSCOUT20$generated.seconds[NSCOUT20$generated.seconds!=Inf])
)
avgdf20 <- data.frame(Algorithm = c("Negamax", "Negamax (w\ alpha-beta)", "Scout", "Negascout"),
                    Solved=solved,
                    Expanded=expanded,
                    Generated=generated,
                    Seconds=seconds,
                    Rate=rates
)
write.csv(avgdf20, "./AvgTable20.csv", row.names = TRUE)

#AHORA SOLO LOS PRIMEROS 17
NMAB17 <- head(NMAB, 17)
SCOUT17 <- head(SCOUT, 17)
NSCOUT17 <- head(NSCOUT, 17)

#Averages table
solved<- c(length(NM$npv), length(NMAB17$npv), length(SCOUT17$npv), length(NSCOUT17$npv))
expanded <- c(mean(NM$expanded.nodes), mean(NMAB17$expanded.nodes), mean(SCOUT17$expanded.nodes), mean(NSCOUT17$expanded.nodes))
generated <- c(mean(NM$generated.nodes), mean(NMAB17$generated.nodes), mean(SCOUT17$generated.nodes), mean(NSCOUT17$generated.nodes))
seconds <- c(mean(NM$seconds), mean(NMAB17$seconds), mean(SCOUT17$seconds), mean(NSCOUT17$seconds))
rates <- c(mean(NM$generated.seconds[NM$generated.seconds!=Inf]),
           mean(NMAB17$generated.seconds[NMAB17$generated.seconds!=Inf]),
           mean(SCOUT17$generated.seconds[SCOUT17$generated.seconds!=Inf]),
           mean(NSCOUT17$generated.seconds[NSCOUT17$generated.seconds!=Inf])
)
avgdf17 <- data.frame(Algorithm = c("Negamax", "Negamax (w\ alpha-beta)", "Scout", "Negascout"),
                      Solved=solved,
                      Expanded=expanded,
                      Generated=generated,
                      Seconds=seconds,
                      Rate=rates
)
write.csv(avgdf17, "./AvgTable17.csv", row.names = TRUE)

#PLOTS GENERAL
ggplot() + geom_line(data=NM, aes(x=npv, y=expanded.nodes, color="NM")) + geom_line(data=NMAB, aes(x=npv, y=expanded.nodes, color="NMAB")) + geom_line(data=SCOUT, aes(x=npv, y=expanded.nodes, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=expanded.nodes, color="NSCOUT")) + labs(title="Nodos expandidos vs. caso", x="Caso", y="Nodos expandidos")
ggplot() + geom_line(data=NM, aes(x=npv, y=generated.nodes, color="NM")) + geom_line(data=NMAB, aes(x=npv, y=generated.nodes, color="NMAB")) + geom_line(data=SCOUT, aes(x=npv, y=generated.nodes, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=generated.nodes, color="NSCOUT")) + labs(title="Nodos generados vs. caso", x="Caso", y="Nodos generados")
ggplot() + geom_line(data=NM, aes(x=npv, y=seconds, color="NM")) + geom_line(data=NMAB, aes(x=npv, y=seconds, color="NMAB")) + geom_line(data=SCOUT, aes(x=npv, y=seconds, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=seconds, color="NSCOUT")) + labs(title="Tiempo vs. caso", x="Caso", y="Tiempo")
ggplot() + geom_line(data=NM, aes(x=npv, y=generated.seconds, color="NM")) + geom_line(data=NMAB, aes(x=npv, y=generated.seconds, color="NMAB")) + geom_line(data=SCOUT, aes(x=npv, y=generated.seconds, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=generated.seconds, color="NSCOUT")) + labs(title="Generados/seg vs. caso", x="Caso", y="Nodos generados/seg")

#PLOTS 20
ggplot() + geom_line(data=NMAB, aes(x=npv, y=expanded.nodes, color="NMAB")) + geom_line(data=SCOUT20, aes(x=npv, y=expanded.nodes, color="SCOUT")) + geom_line(data=NSCOUT20, aes(x=npv, y=expanded.nodes, color="NSCOUT")) + labs(title="Nodos expandidos vs. caso", x="Caso", y="Nodos expandidos")
ggplot() + geom_line(data=NMAB, aes(x=npv, y=generated.nodes, color="NMAB")) + geom_line(data=SCOUT20, aes(x=npv, y=generated.nodes, color="SCOUT")) + geom_line(data=NSCOUT20, aes(x=npv, y=generated.nodes, color="NSCOUT")) + labs(title="Nodos generados vs. caso", x="Caso", y="Nodos generados")
ggplot() + geom_line(data=NMAB, aes(x=npv, y=seconds, color="NMAB")) + geom_line(data=SCOUT20, aes(x=npv, y=seconds, color="SCOUT")) + geom_line(data=NSCOUT20, aes(x=npv, y=seconds, color="NSCOUT")) + labs(title="Tiempo vs. caso", x="Caso", y="Tiempo")
ggplot() + geom_line(data=NMAB, aes(x=npv, y=generated.seconds, color="NMAB")) + geom_line(data=SCOUT20, aes(x=npv, y=generated.seconds, color="SCOUT")) + geom_line(data=NSCOUT20, aes(x=npv, y=generated.seconds, color="NSCOUT")) + labs(title="Generados/seg vs. caso", x="Caso", y="Nodos generados/seg")

#SCOUT VS NEGASCOUT
ggplot() + geom_line(data=SCOUT, aes(x=npv, y=expanded.nodes, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=expanded.nodes, color="NSCOUT")) + labs(title="Nodos expandidos vs. caso", x="Caso", y="Nodos expandidos") 
ggplot() + geom_line(data=SCOUT, aes(x=npv, y=generated.nodes, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=generated.nodes, color="NSCOUT")) + labs(title="Nodos generados vs. caso", x="Caso", y="Nodos generados")
ggplot() + geom_line(data=SCOUT, aes(x=npv, y=seconds, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=seconds, color="NSCOUT")) + labs(title="Tiempo vs. caso", x="Caso", y="Tiempo")
ggplot() + geom_line(data=SCOUT, aes(x=npv, y=generated.seconds, color="SCOUT")) + geom_line(data=NSCOUT, aes(x=npv, y=generated.seconds, color="NSCOUT")) + labs(title="Generados/seg vs. caso", x="Caso", y="Nodos generados/seg")

