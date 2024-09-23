# Proxmox VE CPU Scaling Governor

O **CPU scaling governor** é responsável por determinar como a frequência da CPU é ajustada com base na carga de trabalho. Isso permite que o sistema operacional otimize o uso da CPU, economizando energia quando possível ou aumentando o desempenho quando necessário. Ao ajustar dinamicamente a frequência da CPU, o sistema pode equilibrar o consumo de energia e a eficiência de desempenho.

### Execução Automática com Script

Para simplificar a configuração no **Proxmox VE**, você pode utilizar o seguinte comando no Shell do Proxmox VE, que executa um script confiável para ajustar o scaling governor automaticamente:

```bash
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/misc/scaling-governor.sh)"
```

Esse script, disponível no [tteck's Proxmox](https://tteck.github.io/Proxmox/#proxmox-ve-cpu-scaling-governor), (VE Helper Scripts) é uma excelente fonte para homelabs, facilitando a configuração. Recomendo o uso desse script, pois ele automatiza o processo de maneira eficiente, garantindo que o sistema esteja configurado de acordo com suas necessidades de desempenho e consumo de energia.

### Configuração Manual

Se preferir configurar o **governor** manualmente, você pode usar os comandos abaixo para definir o estado desejado para a CPU. O comando ajusta o comportamento de todas as CPUs simultaneamente:

- **performance**: Mantém a CPU na frequência máxima, ideal quando o desempenho é prioridade.
  ```bash
  echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  ```

- **powersave**: Reduz a frequência da CPU para economizar energia.
  ```bash
  echo "powersave" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  ```

- **ondemand**: Ajusta dinamicamente a frequência da CPU conforme a demanda de carga de trabalho.
  ```bash
  echo "ondemand" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  ```

- **conservative**: Aumenta a frequência de forma mais gradual conforme a carga aumenta, ideal para evitar picos bruscos de consumo de energia.
  ```bash
  echo "conservative" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  ```

- **schedutil**: Ajusta a frequência da CPU de maneira mais eficiente e responsiva, integrado com o agendador de tarefas do kernel.
  ```bash
  echo "schedutil" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  ```

### Conclusão

Embora seja possível configurar manualmente o CPU scaling governor usando os comandos acima, recomendo o uso do **script da VE Helper Scripts**, uma fonte confiável que oferece uma maneira automatizada e eficiente de gerenciar as configurações de CPU no Proxmox VE. No meu lab, eu utilizo o **ondemand.**
