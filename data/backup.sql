--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: decrementa_ingresso_fnc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.decrementa_ingresso_fnc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE evento
		SET ingressos_vendidos = ingressos_vendidos - 1
		WHERE NEW.id_evento = evento.id AND NEW.cancelado = true;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.decrementa_ingresso_fnc() OWNER TO postgres;

--
-- Name: incrementa_ingresso_fnc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.incrementa_ingresso_fnc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
		UPDATE evento
		SET ingressos_vendidos = ingressos_vendidos + 1
		WHERE NEW.id_evento = evento.id;
		RETURN NEW;
	END;
$$;


ALTER FUNCTION public.incrementa_ingresso_fnc() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: apresenta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.apresenta (
    id_banda integer,
    id_evento integer,
    id integer NOT NULL
);


ALTER TABLE public.apresenta OWNER TO postgres;

--
-- Name: apresenta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.apresenta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.apresenta_id_seq OWNER TO postgres;

--
-- Name: apresenta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.apresenta_id_seq OWNED BY public.apresenta.id;


--
-- Name: banda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banda (
    nome character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    senha character varying(256) NOT NULL,
    genero character varying(15) NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.banda OWNER TO postgres;

--
-- Name: banda_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.banda_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.banda_id_seq OWNER TO postgres;

--
-- Name: banda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.banda_id_seq OWNED BY public.banda.id;


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    nome character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    senha character varying(256) NOT NULL,
    cpf character varying(11) NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cliente_id_seq OWNER TO postgres;

--
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- Name: evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evento (
    nome character varying(50) NOT NULL,
    data date NOT NULL,
    horario time without time zone NOT NULL,
    qtd_ingressos integer NOT NULL,
    id_local integer NOT NULL,
    ingressos_vendidos integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.evento OWNER TO postgres;

--
-- Name: evento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evento_id_seq OWNER TO postgres;

--
-- Name: evento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evento_id_seq OWNED BY public.evento.id;


--
-- Name: venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venda (
    cancelado boolean NOT NULL,
    estornado boolean NOT NULL,
    id_cliente integer,
    id_evento integer,
    id integer NOT NULL
);


ALTER TABLE public.venda OWNER TO postgres;

--
-- Name: ingresso; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.ingresso AS
 SELECT cliente.nome AS cliente,
    banda.nome AS banda,
    evento.nome AS evento,
    evento.data,
    evento.horario,
    venda.cancelado,
    venda.estornado
   FROM ((((public.venda
     RIGHT JOIN public.cliente ON ((cliente.id = venda.id_cliente)))
     JOIN public.apresenta ON ((apresenta.id_evento = venda.id_evento)))
     JOIN public.evento ON ((evento.id = apresenta.id_evento)))
     JOIN public.banda ON ((banda.id = apresenta.id_banda)))
  WITH NO DATA;


ALTER TABLE public.ingresso OWNER TO postgres;

--
-- Name: local_show; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.local_show (
    cidade character varying(50) NOT NULL,
    bairro character varying(50) NOT NULL,
    rua character varying(50) NOT NULL,
    cep character varying(20) NOT NULL,
    numero character varying(10),
    id integer NOT NULL
);


ALTER TABLE public.local_show OWNER TO postgres;

--
-- Name: local_show_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.local_show_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.local_show_id_seq OWNER TO postgres;

--
-- Name: local_show_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.local_show_id_seq OWNED BY public.local_show.id;


--
-- Name: show; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.show AS
 SELECT banda.nome AS banda,
    banda.genero,
    evento.nome AS evento,
    evento.data,
    evento.horario,
    evento.qtd_ingressos,
    local_show.cidade,
    local_show.bairro,
    local_show.rua,
    local_show.cep,
    local_show.numero
   FROM (((public.apresenta
     JOIN public.banda ON ((banda.id = apresenta.id_banda)))
     JOIN public.evento ON ((evento.id = apresenta.id_evento)))
     LEFT JOIN public.local_show ON ((local_show.id = evento.id_local)));


ALTER TABLE public.show OWNER TO postgres;

--
-- Name: venda_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.venda_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venda_id_seq OWNER TO postgres;

--
-- Name: venda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.venda_id_seq OWNED BY public.venda.id;


--
-- Name: apresenta id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apresenta ALTER COLUMN id SET DEFAULT nextval('public.apresenta_id_seq'::regclass);


--
-- Name: banda id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banda ALTER COLUMN id SET DEFAULT nextval('public.banda_id_seq'::regclass);


--
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- Name: evento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento ALTER COLUMN id SET DEFAULT nextval('public.evento_id_seq'::regclass);


--
-- Name: local_show id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.local_show ALTER COLUMN id SET DEFAULT nextval('public.local_show_id_seq'::regclass);


--
-- Name: venda id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda ALTER COLUMN id SET DEFAULT nextval('public.venda_id_seq'::regclass);


--
-- Data for Name: apresenta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.apresenta (id_banda, id_evento, id) FROM stdin;
7	8	1
5	5	2
1	7	3
10	2	4
4	3	5
3	2	6
6	1	7
2	4	8
8	8	9
4	6	10
\.


--
-- Data for Name: banda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banda (nome, email, senha, genero, id) FROM stdin;
Sabaton	sabaton-official@email.com	sabaton-bismark	power metal	1
Paramore	paramore-official@email.com	ignorancethecode	alternativo	2
Dragon Force	dragonforce-official@email.com	throughtheflames-tztopper	power metal	3
The Hu	thehu-official@email.com	huarewe-sadbuttrue	folk	4
Rammstein	rammstein-official@email.com	duriechstsogut94	industrial	5
Disturbed	disturberd-official@email.com	sickness-disturbed	heavy metal	6
Metallica	metallica-official@email.com	killemall83	heavy metal	7
Iron Maiden	ironmaiden-official@email.com	callofcthulhu	heavy metal	8
A Day to Remember	adaytoremember-official@email.com	forthoseshowhaveheart	alternativo	9
Pearl Jam	pearljam-official@email.com	lightningbolt	grunge	10
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (nome, email, senha, cpf, id) FROM stdin;
Guthyerri	guthyerrialex@email.com	guthyerri123	42352363421	1
Davi	davisf@email.com	davi423	14263480212	2
Rafaela	rafatrajano@email.com	trajandoplano	92174202167	3
Gabriely	gabriely_gabi@email.com	gabi452oli	29361285064	4
Isaias	isazstoledo@email.com	matrix_neo512	02373498902	5
Beatriz	goiabia@email.com	beatrix_goiabia	76521356352	6
Lucas	lucas_macedox@email.com	macedo_ld521[]	15975368458	7
Adriano	oliveiraandrias@email.com	alestoraandriax	86528940283	8
Emily	emilyefanygwe@email.com	davi423	02516848269	9
Jurandir	jurandosegredo@email.com	jurasqueparque	45872619380	10
\.


--
-- Data for Name: evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evento (nome, data, horario, qtd_ingressos, id_local, ingressos_vendidos, id) FROM stdin;
Steamskull	2024-05-10	16:00:00	6015	6	3075	1
Meromor	2022-04-30	21:20:00	3212	7	742	2
Lolo	2023-05-10	21:20:00	10000	2	2522	3
Louki	2022-04-28	19:00:00	1000	1	354	4
Wave	2022-07-03	20:30:00	2000	4	796	5
Sepulkro	2023-01-01	00:00:00	30000	5	12543	6
Fortal 2019	2022-06-12	20:00:00	2000	3	947	7
Konquest	2024-11-02	20:00:00	40500	10	23623	8
Alkaceil	2022-06-16	19:30:00	4022	9	976	9
Steinbroke	2023-03-12	17:30:00	5240	8	2518	10
\.


--
-- Data for Name: local_show; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.local_show (cidade, bairro, rua, cep, numero, id) FROM stdin;
S├úo Paulo	Swiss Park	Rua 130	62234021	232	1
Osasco	S├úo Vicente	Rua 232	61424051	4212	2
Rio de Janeiro	Tijuca	Rua 425	65132052	652	3
Fortaleza	Bom Jardim	Rua 521	6512502	823	4
Fortaleza	Panamericano	Rua 942	68914201	1324	5
Bras├¡lia	Asa Norte	Rua 520	63905321	8202	6
Santos	Embar├®	Rua 1512	60322072	7123	7
Salvador	Caminho das ├ürvores	Rua 4232	52623021	10223	8
Porto Alegre	Aberta dos Morros	Rua 923	74232823	64242	9
S├úo Paulo	Ponte Preta	Rua 512	62234042	82312	10
\.


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venda (cancelado, estornado, id_cliente, id_evento, id) FROM stdin;
f	f	1	3	0
f	f	7	6	12
f	f	2	4	13
f	f	5	2	14
f	f	10	5	15
f	f	8	2	16
f	f	4	8	17
f	f	3	8	18
f	f	6	10	19
f	f	1	6	20
\.


--
-- Name: apresenta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.apresenta_id_seq', 10, true);


--
-- Name: banda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.banda_id_seq', 10, true);


--
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 10, true);


--
-- Name: evento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evento_id_seq', 10, true);


--
-- Name: local_show_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.local_show_id_seq', 10, true);


--
-- Name: venda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.venda_id_seq', 21, true);


--
-- Name: apresenta apresenta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apresenta
    ADD CONSTRAINT apresenta_pkey PRIMARY KEY (id);


--
-- Name: banda banda_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banda
    ADD CONSTRAINT banda_email_key UNIQUE (email);


--
-- Name: banda banda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banda
    ADD CONSTRAINT banda_pkey PRIMARY KEY (id);


--
-- Name: cliente cliente_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_email_key UNIQUE (email);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- Name: evento evento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT evento_pkey PRIMARY KEY (id);


--
-- Name: local_show local_show_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.local_show
    ADD CONSTRAINT local_show_pkey PRIMARY KEY (id);


--
-- Name: venda venda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: venda decrementa_ingresso; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER decrementa_ingresso AFTER UPDATE ON public.venda FOR EACH ROW EXECUTE FUNCTION public.decrementa_ingresso_fnc();


--
-- Name: venda incrementa_ingresso; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER incrementa_ingresso AFTER INSERT ON public.venda FOR EACH ROW EXECUTE FUNCTION public.incrementa_ingresso_fnc();


--
-- Name: ingresso; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.ingresso;


--
-- PostgreSQL database dump complete
--

