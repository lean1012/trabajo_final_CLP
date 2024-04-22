library IEEE;
use IEEE.std_logic_1164.all;

entity float32VIO is

	port (
		clk : in std_logic
	);
end;

architecture float32VIO_arq of float32VIO is

	component regNb is
		generic (
			N : natural := 4
		);
		port (
			clk_i : in  std_logic;
			rst_i : in  std_logic;
			ena_i : in  std_logic;
			d_i   : in  std_logic_vector(N - 1 downto 0);
			q_o   : out std_logic_vector(N - 1 downto 0)
		);
	end component;

	component floatpoint_adder is
		generic (
			PRECISION_BITS : natural := 32
		);

		port (
			a_i     : in  std_logic_vector(PRECISION_BITS - 1 downto 0);
			b_i     : in  std_logic_vector(PRECISION_BITS - 1 downto 0);
			start_i : in  std_logic;
			s_o     : out std_logic_vector(PRECISION_BITS - 1 downto 0);
			done_o  : out std_logic;
			rst     : in  std_logic;
			clk     : in  std_logic
		);
	end component;

	component vio_0
		port (
			clk        : in  std_logic;
			probe_in0  : in  std_logic_vector(31 downto 0);
			probe_in1  : in  std_logic_vector(0 downto 0);
			probe_out0 : out std_logic_vector(31 downto 0);
			probe_out1 : out std_logic_vector(31 downto 0);
			probe_out2 : out std_logic_vector(0 downto 0);
			probe_out3 : out std_logic_vector(0 downto 0)
		);
	end component;

	signal probe_a     : std_logic_vector(31 downto 0);
	signal probe_b     : std_logic_vector(31 downto 0);
	signal probe_start : std_logic_vector(0 downto 0);
	signal probe_out   : std_logic_vector(31 downto 0);
	signal probe_done  : std_logic_vector(0 downto 0);
	signal probe_rst   : std_logic_vector(0 downto 0);

	signal r0_input : std_logic;
	signal r1_input : std_logic;
	signal sg       : std_logic;
	signal done_aux : std_logic;
	signal so_aux   : std_logic_vector(31 downto 0);

begin

	regNb_inst : regNb
	generic map(
		N => 32
	)
	port map(
		clk_i => clk,
		rst_i => probe_rst(0),
		ena_i => probe_done(0),
		d_i   => so_aux,
		q_o   => probe_out
	);
	vio_inst : vio_0
	port map(
		clk        => clk,
		probe_in0  => probe_out,
		probe_in1  => probe_done,
		probe_out0 => probe_a,
		probe_out1 => probe_b,
		probe_out2 => probe_start,
		probe_out3 => probe_rst
	);
	floatpoint_adder_inst : floatpoint_adder
	generic map(
		PRECISION_BITS => 32
	)
	port map(
		a_i     => probe_a,
		b_i     => probe_b,
		start_i => sg,
		s_o     => so_aux,
		done_o  => probe_done(0),
		rst     => probe_rst(0),
		clk     => clk
	);

	p_rising_edge_detector : process (clk, probe_rst(0))
	begin
		if (probe_rst(0) = '1') then
			r0_input <= '0';
			r1_input <= '0';
		elsif (rising_edge(clk)) then
			r0_input <= probe_start(0);
			r1_input <= r0_input;
		else
			r0_input <= r0_input;
			r1_input <= r1_input;
		end if;
		sg <= not r1_input and r0_input;
	end process p_rising_edge_detector;

end;