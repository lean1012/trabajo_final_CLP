# Trabajo Final para la materia Circuitos Lógicos Programables Co20

## Sumador punto flotante 32bits y 64bits

El repositorio implementa un bloque sumador punto flotante floatpoint_adder.vhd. Este sumador realiza la suma en precisión simple (32 bits) o precisión doble (64 bits) de dos números. A continuación la instancia del componente para una suma de 32 bits.

 component floatpoint_adder is
   generic (
   PRECISION_BITS: natural := 32
   );

   port(
     a_i: in std_logic_vector(PRECISION_BITS-1 downto 0);
     b_i: in std_logic_vector(PRECISION_BITS-1 downto 0);
     start_i: in std_logic;
     s_o: out std_logic_vector(PRECISION_BITS-1 downto 0);
     done_o: out std_logic;
     rst: in std_logic;
     clk: in std_logic
   );
 end component;

El bloque tiene las siguientes entradas:
a y b: números a sumar.
clk.
rst. 
start_i : start_i en 1 indica que se quiere realizar la suma de a con b. 


El bloque tiene las siguientes salidas:
done_o : indica que se realizó la suma y el resultado en s_o es válido.
s_o: resultado de la suma a + b.

Para realizar la suma, se deben introducir los números a sumar en formato punto flotante en las entradas a_i y b_i y luego dar un pulso en start_i. El resultado estará en s_o y solo será válido cuando la salida done_o esté en alto. Se recomienda utilizar un pulso de un período de reloj en start_i para evitar la repetición del cálculo al finalizar.

Para la prueba en la placa se utilizó un VIO, un registro de 32bits para guardar el resultado y un detector de flanco para iniciar la cuenta. El archivo top level es float32VIO.vhd

## Documento Documento_trabajo_práctico final_Sumador_punto_flotante.pdf
En el documento Documento_trabajo_práctico final_Sumador_punto_flotante.pdf se encuentra una descripción más detallada de la implementación

## Diapositivas
En el siguiente link se encuentra la presentación del sumador punto flotante: 
https://docs.google.com/presentation/d/1ZmaKEmnyOG59cEtiW_Uo4MWKhB7XvX6ljM6tislQT6U/edit#slide=id.gf773441448_0_18

##Esquematico y simulaciones
schematic_float_adder.pdf se encuentra el esquematico RTL del sumador punto flotante y simulacion1.png, simulacion2.png, simulacion3.png son capturas de las simulaciones descriptas en el documento.