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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: apresenta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.apresenta (
    id_banda integer,
    id_evento integer
);


ALTER TABLE public.apresenta OWNER TO postgres;

--
-- Name: banda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.banda (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    senha character varying(256) NOT NULL,
    genero character varying(15) NOT NULL
);


ALTER TABLE public.banda OWNER TO postgres;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    senha character varying(256) NOT NULL,
    cpf character varying(11) NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: evento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evento (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    data date NOT NULL,
    horario time without time zone NOT NULL,
    qtd_ingressos integer NOT NULL,
    id_local integer
);


ALTER TABLE public.evento OWNER TO postgres;

--
-- Name: venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venda (
    cancelado boolean NOT NULL,
    estornado boolean NOT NULL,
    id_cliente integer,
    id_evento integer
);


ALTER TABLE public.venda OWNER TO postgres;

--
-- Name: ingresso; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.ingresso AS
 SELECT cliente.id AS cliente,
    banda.id AS banda,
    evento.nome AS evento,
    evento.data,
    evento.horario,
    venda.cancelado,
    venda.estornado
   FROM ((((public.venda
     JOIN public.cliente ON ((cliente.id = venda.id_cliente)))
     JOIN public.apresenta ON ((apresenta.id_evento = venda.id_evento)))
     JOIN public.evento ON ((evento.id = apresenta.id_evento)))
     JOIN public.banda ON ((banda.id = apresenta.id_banda)));


ALTER TABLE public.ingresso OWNER TO postgres;

--
-- Name: local_show; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.local_show (
    id integer NOT NULL,
    cidade character varying(50) NOT NULL,
    bairro character varying(50) NOT NULL,
    rua character varying(50) NOT NULL,
    cep character varying(20) NOT NULL,
    numero character varying(10)
);


ALTER TABLE public.local_show OWNER TO postgres;

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
-- Data for Name: apresenta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.apresenta (id_banda, id_evento) FROM stdin;
7	8
5	5
1	7
10	2
4	3
3	2
6	1
2	4
8	8
4	6
\.


--
-- Data for Name: banda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.banda (id, nome, email, senha, genero) FROM stdin;
1	Sabaton	sabaton-official@email.com	sabaton-bismark	power metal
2	Paramore	paramore-official@email.com	ignorancethecode	alternativo
3	Dragon Force	dragonforce-official@email.com	throughtheflames-tztopper	power metal
4	The Hu	thehu-official@email.com	huarewe-sadbuttrue	folk
5	Rammstein	rammstein-official@email.com	duriechstsogut94	industrial
6	Disturbed	disturberd-official@email.com	sickness-disturbed	heavy metal
7	Metallica	metallica-official@email.com	killemall83	heavy metal
8	Iron Maiden	ironmaiden-official@email.com	callofcthulhu	heavy metal
9	A Day to Remember	adaytoremember-official@email.com	forthoseshowhaveheart	alternativo
10	Pearl Jam	pearljam-official@email.com	lightningbolt	grunge
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id, nome, email, senha, cpf) FROM stdin;
1	Guthyerri	guthyerrialex@email.com	guthyerri123	42352363421
2	Davi	davisf@email.com	davi423	14263480212
3	Rafaela	rafatrajano@email.com	trajandoplano	92174202167
4	Gabriely	gabriely_gabi@email.com	gabi452oli	29361285064
5	Isaias	isazstoledo@email.com	matrix_neo512	02373498902
6	Beatriz	goiabia@email.com	beatrix_goiabia	76521356352
7	Lucas	lucas_macedox@email.com	macedo_ld521[]	15975368458
8	Adriano	oliveiraandrias@email.com	alestoraandriax	86528940283
9	Emily	emilyefanygwe@email.com	davi423	02516848269
10	Jurandir	jurandosegredo@email.com	jurasqueparque	45872619380
\.


--
-- Data for Name: evento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evento (id, nome, data, horario, qtd_ingressos, id_local) FROM stdin;
1	Lolo	2023-05-10	21:20:00	10000	2
2	Fortal 2019	2022-06-12	20:00:00	2000	3
3	Louki	2022-04-28	19:00:00	1000	1
4	Wave	2022-07-03	20:30:00	2000	4
5	Sepulkro	2023-01-01	00:00:00	30000	5
6	Steinbroke	2023-03-12	17:30:00	5240	8
7	Steamskull	2024-05-10	16:00:00	6015	6
8	Konquest	2024-11-02	20:00:00	40500	10
9	Meromor	2022-04-30	21:20:00	3212	7
10	Alkaceil	2022-06-16	19:30:00	4022	9
\.


--
-- Data for Name: local_show; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.local_show (id, cidade, bairro, rua, cep, numero) FROM stdin;
1	S├úo Paulo	Swiss Park	Rua 130	62234021	232
2	Osasco	S├úo Vicente	Rua 232	61424051	4212
3	Rio de Janeiro	Tijuca	Rua 425	65132052	652
4	Fortaleza	Bom Jardim	Rua 521	6512502	823
5	Fortaleza	Panamericano	Rua 942	68914201	1324
6	Bras├¡lia	Asa Norte	Rua 520	63905321	8202
7	Santos	Embar├®	Rua 1512	60322072	7123
8	Salvador	Caminho das ├ürvores	Rua 4232	52623021	10223
9	Porto Alegre	Aberta dos Morros	Rua 923	74232823	64242
10	S├úo Paulo	Ponte Preta	Rua 512	62234042	82312
\.


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.venda (cancelado, estornado, id_cliente, id_evento) FROM stdin;
f	f	9	1
f	f	1	3
f	f	7	6
f	f	2	4
f	f	5	2
f	f	10	5
f	f	8	2
f	f	4	8
f	f	3	8
f	f	6	10
\.


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
-- Name: local_show local_show_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.local_show
    ADD CONSTRAINT local_show_pkey PRIMARY KEY (id);


--
-- Name: evento show_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evento
    ADD CONSTRAINT show_event_pkey PRIMARY KEY (id);


--
-- Name: apresenta apresenta_id_banda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apresenta
    ADD CONSTRAINT apresenta_id_banda_fkey FOREIGN KEY (id_banda) REFERENCES public.banda(id);


--
-- Name: apresenta apresenta_id_show_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.apresenta
    ADD CONSTRAINT apresenta_id_show_fkey FOREIGN KEY (id_evento) REFERENCES public.evento(id);


--
-- Name: venda venda_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id);


--
-- Name: venda venda_id_show_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_show_fkey FOREIGN KEY (id_evento) REFERENCES public.evento(id);


--
-- PostgreSQL database dump complete
--

