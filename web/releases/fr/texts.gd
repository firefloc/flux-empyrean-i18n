# Genere par tools/gen_texts_gd.py — ne pas editer a la main.
extends Node

var texts = {
		"A Bargain for Gnosis": [
			"On parle de notre rencontre comme s'il s'agissait d'un mythe. Ils murmurent mon nom avec la même peur que le tien.",
			"Et pourtant rien ne nous lie. Tu m'as tout pris. Rien de ce que je suis aujourd'hui n'était là quand je t'ai rencontré.",
			"Je veux seulement savoir quelle a été ma réponse. Laisse-moi ça. Tu as pris tout le reste.",
		],
		"A Case for Geometics": [
			"Chers confrères,\nJe vous écris aujourd'hui pour mettre les choses au clair. Nombre d'entre vous disent que j'ai été négligent, que j'ai commis une faute d'orthographe majeure dans mon dernier travail, en employant le terme « géométique » au lieu de « géométrique ».",
			"Aujourd'hui, je tranche le débat. Mon orthographe était intentionnelle. Si j'ai appelé mon laboratoire le Geometic Lab, c'est parce que ce nom décrit au mieux mes recherches.",
			"Je n'étudie pas seulement la géométrie. J'étudie la géométrie, et son application au monde qui nous entoure. D'où le terme que j'ai forgé : les géométiques.\n\nAvec bienveillance,\nSocar",
		],
		"A Commentary On Ayodhia": [
			"Il est bien clair que les anciens éprouvaient pour Ayodhia une révérence d'une nature différente de la nôtre aujourd'hui. De nos jours, la montagne est surtout un point de repère, une icône, mais ce n'est pas un lieu. Nous n'y allons que rarement.",
			"Pour les anciens, c'est la Sainte Montagne. Un lieu où communier avec les divinités. La plus sainte des terres saintes d'Umai. Pourquoi avons-nous perdu cette beauté ? Qu'est-ce qui a changé ?",
			"Quelque chose a-t-il seulement changé ? La question me reste. Est-ce la montagne qui est devenue autre chose, ou avons-nous simplement oublié ce qu'elle est ?",
			"Ou bien n'est-ce pas que nous avons oublié ce qu'est la montagne, mais que nous avons oublié ce qu'elle contient ?",
		],
		"A Declaration of War": [
			"Il est des mots qui ne devraient jamais voir le jour aussi facilement.",
			"Il est des choses trop lourdes à porter pour nous.",
			"Mais quand nous sommes témoins de ce que les Réalistes ont fait,\nl'indicible rendu vivant,",
			"alors nous devons réagir par des actes trop impensables à porter.",
		],
		"A Hunt of Futility": [
			"Est-ce toi qui as élu domicile chez moi ?",
			"Longtemps j'ai cherché l'intrus, et pourtant je n'ai trouvé personne.",
			"Pourtant, je me suis retrouvé, maintes et maintes fois, à te trouver.",
			"Tu n'as pas à me dire de qui il s'agit. Dis-moi seulement si ma chasse a une réponse.",
		],
		"A Miracle": [
			"La Cité a été amarrée.",
		],
		"A Thought": [
			"Si je devais invoquer une divinité au nom du jugement, qui pourrait aller jusqu'au bout ?",
			"Je crois savoir qui, mais je ne supporterais pas d'en voir le visage.",
		],
		"A True Plan": [
			"BZUAVPSMIETXEVUPQMPMFDMOKZAJIFEWZSQFDBTAQZPMDOMOPQAJWROXMYM",
			"XCFBQDOBIAUGOBREVPWEMUBAOBALBTAUMNKTEVSKNFEUQ",
		],
		"Absurdity": [
			"Sois honnête avec toi-même. Combien de bombes nous ont-ils larguées ? Je n'arrive pas à donner un sens à la chronologie. Et toi ?",
			"Quelque chose d'essentiel a été perdu. Je sais que le domaine conceptuel existe et que la matière est finie. Je crains qu'un grand basculement n'ait eu lieu.",
			"Je me demande où mes amis sont passés, en ce moment même.",
		],
		"Aeons": [
			"--L'Aeon Extant, Préexistence--\nSans description.",
			"--Le Premier Aeon, Création--\nToutes les idées existent depuis toujours. Quand la faille s'ouvrit, les idées affluèrent dans la réalité.",
			"--Le Deuxième Aeon, Cultivation--\nCertaines idées en repoussèrent d'autres. La réalité se solidifia à mesure que seules les idées les plus fortes subsistaient.",
			"--Le Troisième Aeon, Stagnation--\nLe flot des idées ralentit et la vie se fit rare.",
			"--Le Quatrième Aeon, Immobilité--\nLa forme finale de l'univers.",
		],
		"An Introduction to Logic": [
			"Félicitations ! Voici l'un des textes les plus décisifs que vous lirez jamais. Vous êtes-vous déjà demandé quelles règles gouvernent notre monde ? Avez-vous déjà souhaité mieux comprendre ce qui vous entoure ? Ou souhaité mieux réfléchir à ce qu'il convient de faire ? La logique est la réponse à ces problèmes.\n\nCommençons par les fondations. Nous allons voir quelques briques élémentaires à partir desquelles tout se construira. De n'importe quel énoncé, on peut dire qu'il est soit vrai, soit faux. Les termes ne manquent pas pour désigner cela : allumé et éteint, oui et non, ou, celle que je préfère, 1 et 0. Voici quelques exercices simples pour vérifier que vous avez bien compris.",
			"Pour chaque question, répondez si l'énoncé suivant est vrai ou faux.\n1. La plus grande planète est Xeres.\n2. Le ciel est empli de flux.\n3. La plus petite planète est Umai.\n4. Cora est la patronne de la logique.\n5. Il y a quatre questions dans cette série.\nTentez votre chance.\n\nVoici maintenant les réponses :\n1. Vrai.\n2. Vrai.\n3. Faux.\n4. Vrai\n5. Faux.",
			"Parfait ! Maintenant que nous savons classer les énoncés, nous pouvons employer de nouvelles règles pour les organiser et gagner en profondeur. Laissez-moi introduire quelques nouveaux énoncés élémentaires, que nous explorerons plus en détail par la suite. Dans ce qui suit, s désignera un énoncé qui est soit vrai, soit faux.\n1. Et = s ^ s\n2. Ou = s v s\n3. Non = -s\n4. Si Alors = s -> s \nTous ces énoncés peuvent être simplifiés ou évalués jusqu'à une unique valeur de vérité, 1 ou 0. Avec ces règles, nous pouvons combiner plusieurs énoncés logiques en un seul. C'est ainsi que nous pouvons tirer du monde une vérité plus profonde.\n",
			"À titre d'exemple, prenons le débat autour des divinités - sont-elles réelles ? Voici un argument en faveur de leur existence. (Il est peut-être bien formé, peut-être pas... à vous d'en juger !)\n\ta = Les divinités causent par définition des forces invisibles.\n\tb = Il existe des forces invisibles qui agissent dans ce monde.\n\tc = Les divinités existent.\nNotre but est de prouver que la proposition c est vraie. Si vous accordez que a et b sont vrais tous les deux, alors nous pouvons soutenir :\n\t(a ^ b) -> c\nCe qui se traduit par « Si les divinités causent par définition des forces invisibles, et qu'il existe des forces invisibles dans le monde, alors les divinités existent ». Vous y croyez ? Si vous acceptez a et b, alors c doit être vrai, selon cet argument. \n\nBien que l'exemple précédent soit bon pour apprendre, ne vous en servez pas comme d'un vrai argument. Notre raisonnement comporte de nombreuses failles, croyez-le ou non. Nos deux prémisses n'impliquent pas c, parce que nous n'établissons jamais que les divinités sont la seule cause des forces invisibles, entre autres choses.",
		],
		"An Uncomfortable Reality": [
			"Qu'est-ce qui a fait les étoiles ? Quelle que soit la réponse, la plupart d'entre nous penseraient que cela devrait les répartir de façon à peu près uniforme autour de nous. Dans l'ensemble, c'est bien le cas.",
			"Mais cela ne vaut pas partout. Après analyse, nous sommes convaincus qu'il existe, le long de l'axe des Parallels, un anneau d'étoiles ténu mais distinct. Les propriétés de cet anneau diffèrent notablement de celles des autres étoiles du ciel. On ne sait pas encore si Corin avait connaissance de cet anneau à l'époque de la construction des Parallels.",
			"Nous n'avons pas encore de théorie solide pour expliquer ce que nous observons ici, mais quelques candidates se présentent. Je dirais qu'elles se rangent grossièrement en deux grandes catégories : les umaicentriques et les anticentriques. La position à laquelle vous adhérez dépend de la façon dont vous interprétez deux faits importants.",
			"L'anneau stellaire ne s'aligne sur Umai d'aucune manière significative, hormis l'axe des Parallels, mais on pourrait objecter que c'est à cause des étoiles qu'on a bâti les Parallels à cet endroit. Certains disent que ce défaut d'alignement est la preuve que le monde n'est pas centré sur nous.",
			"D'autres invoquent les étoiles de l'anneau. D'après les observations, leur densité est uniforme sur tout le pourtour de l'anneau. Ce ne serait le cas que si nous étions véritablement au centre de celui-ci. Si nous en occupions le bord, une partie de notre ciel serait plus densément peuplée d'étoiles.",
			"Quant à ma position, je commence à penser que nous, sur Umai, sommes plus singuliers que la position réaliste habituelle ne voudrait vous le faire croire.",
		],
		"Ancient Engravings": [
			"~\nAinsi, Tor brûla et tomba ! Et cela était bon.\n~",
			"~\nLe Vert les mit à genoux, puis en cendres.\n~",
			"~\nHélas, les Hurz ne purent supporter la lumière du Soleil rouge.\n~",
			"~\nNul ne put véritablement conquérir Jewel. \n~",
			"~\nQuand le Soleil jaune ne vint jamais et que l'Étoile bleue manqua de lumière...\n~",
			"~\nTyrannus sut quoi faire.\n~",
			"~\nEt cela était bon.\n~",
		],
		"Archival Notes": [
			"Veillez à ne pas faire entrer dans la réalité tout ce que vous voyez ici ! Certaines choses gagnent à rester de simples expériences de pensée.",
			"Nous voulions classer et catégoriser les idées présentées ici, mais nous avons vite compris que la tâche serait impossible ! Beaucoup de ces concepts sont tout simplement trop imprévisibles pour qu'on puisse leur assigner un ordre véritable.",
			"Cette archive existe parce que le monde est fait d'idées. Même si toutes les idées ne sont pas réelles, nous pouvons apprendre sur notre monde en méditant sur ce qu'il serait si telle ou telle idée l'était.",
		],
		"Art of Secrecy": [
			"J'ai conçu cet appareil de communication pour que nous puissions échanger librement nos informations sans craindre d'être pris. Sachez-le : la clé de ce message est la clé de tous les messages contenus dans des appareils semblables. Gardez-la donc secrète, car si l'on connaît la clé de l'un, on détient la clé de tous.",
		],
		"Authorization": [
			"Si vous lisez ceci, c'est que je ne suis plus là. J'espère que nos ennemis ont été détruits. Et s'ils ne le sont pas, alors ne craignez rien. Il reste de l'espoir.",
			"Stein, s'il a fait ce qu'on lui a dit, devrait avoir préparé une dernière bombe. Le terminal qui permet de la lancer est le terminal PXCSAW. Il devrait avoir laissé les codes quelque part.",
			"Je vous donne mon autorisation. Le code ne fonctionnera pas sans le bon ordre. Une mesure de sécurité. C'est PCXSAW, et non PXCSAW.",
		],
		"Balance": [
			"S'il n'y avait pas de divinités, il n'y aurait pas non plus de dons de leur part. Pour qu'une chose quelconque soit le don d'une divinité, il faut qu'elle en reflète les aspects.",
			"Cora est la paix, la stabilité et la logique qui gouvernent nos vies. Regardez le Corba : sa forme parfaite incarne ces idéaux.",
			"Parfaitement équilibré et sans inclinaison, il est stable. Dans sa posture statique, nous trouvons la paix. Et dans sa construction — six faces, huit coins — nous voyons une logique de construction. On n'y trouve aucune irrégularité.",
		],
		"Beyond Deities": [
			"Nous parlons souvent des divinités. Les Idéalistes consacrent leurs études à toutes, tandis que les Abstractistes et les Logiciens en choisissent une pour patron. Mais tous voient leurs patrons comme des divinités.",
			"Et je ne crois pas que ce soit un abus de langage. Mais je ne peux m'empêcher de me demander : pourquoi rechignons-nous à les appeler des dieux ? Nolud est l'un des rares à s'y résoudre, et pour une raison intéressante. Il a fait une rencontre plus profonde que ce dont la plupart des gens peuvent rêver.",
			"Le nom de dieu convoque plus de puissance que celui de divinité. Nos divinités correspondent certainement mieux au titre qu'elles portent déjà qu'à celui de dieu. Elles sont réelles, elles agissent, mais elles n'agissent pas avec une puissance immense.",
			"Et si cela pouvait changer ? Et si l'on pouvait pousser une divinité à devenir un dieu ?",
		],
		"Blessing of War": [
			"Accorde-moi la force qui me manque. Permets-moi d'appeler et d'agir sans tarder quand je fais face à l'injustice.",
			"Si je m'égare, accorde que je les arrête, même si je me détruis moi-même.",
			"Veille à ce que, si je meurs, ils ne détruisent pas les riches traditions de notre monde au nom de leur matérialisme.",
		],
		"Boat User's Manual": [
			"Si tu lis ces lignes, c'est que tu es le capitaine d'un de mes bateaux ! Tu peux être fier de toi. Peu de gens vont aussi loin. Tu as excellé dans ton travail, et je compte bien te voir continuer.",
			"INDICATEUR DE VITESSE\nÀ la proue du bateau, tu trouveras la barre, le cardan et l'indicateur de vitesse. Je commence par l'indicateur de vitesse, le plus simple du lot à expliquer. Tu devrais voir un cercle lumineux. Plus tu vas vite, plus il grossit !",
			"CARDAN\nLe cardan représente la rotation des étoiles au-dessus de toi. Les symboles vert et magenta, plus et moins, te servent de boussole. Si tu navigues le long de ces directions, les étoiles tourneront de manière prévisible. C'est très utile pour la navigation.",
			"BARRE & COMMANDE DE VITESSE\nTa barre est simple à prendre en main. Tu peux diriger le bateau à gauche et à droite, mais tu disposes aussi d'une commande de vitesse. Fais très attention à ta vitesse ! Le bateau met un certain temps à accélérer. Le bateau est intelligent : il ne s'autorise à prendre de la vitesse que si tu es à la barre.",
			"ÉVITEMENT DE COLLISION\nEn allant vers l'arrière, tu trouveras le panneau d'évitement de collision. Si tu es en route pour heurter quelque chose, il s'allume et arrête le bateau. Si cela se produit, oriente le bateau à l'opposé de l'objet.",
			"COMMANDES DE VOILE\nJuste à côté, tu trouveras les commandes pour déployer et orienter la voile. Pour une vitesse idéale, il faut que la voile s'aligne d'aussi près que possible sur la girouette du mât.",
			"RADIO & RADAR\nÀ droite de tout cela se trouve la radio. Tu peux te caler sur différentes fréquences et voir si tu captes quelque chose d'intéressant. À côté de la radio, le radar : il balaie et marque les lieux proches, autour de toi.",
			"BOUSSOLE À FRÉQUENCES\nTout à droite se trouve la boussole à fréquences. Tu peux saisir une fréquence, puis appuyer sur la touche « set ». Si quelque chose émet cette fréquence, la boussole pointera vers cette chose.\n\nUne fois que le bateau aura découvert assez du monde pour savoir où tout se trouve, il devrait être capable de naviguer jusqu'à certains lieux du journal.",
			"Le reste de ton navire est aménagé à ton goût ! Fais bon usage de ce savoir au fil de tes nombreuses aventures !",
		],
		"Bounds of Computation": [
			"Les Logiciens se sont effondrés parce qu'ils n'ont pas su concilier la logique et la réalité. Nous avons hérité de leur tradition : hériterons-nous aussi de leur sort ?",
			"La cause réaliste a toujours été de comprendre ce monde, de le cataloguer et d'en prendre le contrôle. Nous croyons qu'il existe des règles pour toute chose et qu'avec assez d'informations, nous pouvons les connaître et les employer.",
			"Mais il m'arrive souvent, dans mon travail, de tomber sur des choses que je ne parviens pas à résoudre. Des problèmes qui semblent inconnaissables. Serons-nous capables de concilier l'empirisme et la réalité ?",
			"Je me considère comme un homme instruit. Les récits et les mythes de la grande montagne Ayodhia me fascinent. Ils n'ont rien à voir avec le monde où je vis. Un jour, j'aimerais m'y rendre. Peut-être y verrai-je enfin des réponses à mes questions.",
		],
		"Brand New God": [
			"Il y a des divinités dans ce monde, mais si vous creusez plus profond, vous découvrirez qu'il y a aussi des dieux. Ils s'attardent dans les ténèbres, souvent sans nom, inaperçus, et pourtant ils manipulent encore le monde au gré de leurs caprices.",
			"J'ai rencontré un jour quelqu'un qui poursuivait un dieu. Cette personne n'y est toujours pas parvenue. Moi, par chance, j'ai un autre plan. Plutôt que de trouver un dieu, pourrais-je en fabriquer un ?",
			"Wim tourne autour du Soleil sans jamais faillir. Le Soleil, une chose si souvent négligée... l'arbitre sans nom du temps. Je crois que le Soleil est un dieu.",
			"Mais le Soleil est un piètre dieu. Contrairement aux divinités, ou aux autres dieux sans nom, le Soleil n'a jamais agi. Le Soleil est silencieux, constant, et sans volonté.",
			"Je veux placer ma foi dans un dieu qui en soit digne. Quand on regarde plus profond, le bon choix devient douloureusement évident. Lisez les mythes. Wim le veut. J'ai l'intention de prendre part à la grande farce.",
		],
		"Celestial Clocks": [
			"Il a toujours été évident que les planètes fonctionnent par cycles, mais faute d'instruments adéquats nous n'avons jamais pu comprendre véritablement ce phénomène.",
			"Notre réseau d'observation nous a fourni assez de données pour comprendre, suivre et prédire les planètes.",
			"La vitesse de chaque planète relative au soleil est la suivante :\nWim: 3.92\nAtrae: 2.95\nXeres: 1.25\nParabol: 1.07\nCora: 1.50\nSiciphos: 0.38",
			"Ces données indiquent que nous avons eu raison de choisir Parabol comme centre de notre réseau. C'est lui qui épouse le plus étroitement le cycle du soleil, et sa présence est constante.",
			"La planète que nous avons récemment découverte à Ayodhia échappe jusqu'ici à toutes nos tentatives pour la suivre et en tirer des données exploitables. Aucun de nos modèles actuels ne parvient à l'expliquer.",
		],
		"Celestial Signs": [
			"Les étoiles au-dessus de nous offrent une tapisserie minutieuse où le passé vient se loger. Au fil du temps, nous avons montré les étoiles du doigt et en avons tiré des figures, leur donnant forme et sens. Pour beaucoup d'entre elles, nous savons encore pourquoi elles ont reçu leur nom. Pour les autres, la simple spéculation reste notre meilleur outil.",
			"Le Cerf\nJe commence par quelques-unes des constellations qui nous demeurent largement inconnues. Le mythe veut que les « cerfs » soient de grandes bêtes à cornes, maîtresses des collines onduleuses. ",
			"Le Crabe\nComme pour le Cerf, nous n'avons guère d'explication concrète à ce symbole. Les légendes parlent de grands titans cuirassés qui déchirent toute matière.",
			"La Colombe\nEn un temps antérieur au temps lui-même, cet être immense aurait habité le ciel comme s'il s'était agi de la terre ferme. Bien entendu, il n'en subsiste aujourd'hui aucune trace.",
			"Le Lapin\nLa dernière des véritables grandes inconnues. Certains disent que la terre sous les collines relevait de leur domaine.",
			"GEGIVQPVVCBFOFJFGUOZQIHILPRLURORQGZRLVLEJHRIUGDCLVBKRILMHYDPWQVFPGWYLPJEHYWYHADIHOLJWCNVQHRIWJHWOQZFIVKVXPLMHTVVVVDKHUWYDVDCOVKZQIVDXUWTKCQXHHRIWJLJLUWYHHOLAVKRWTXCHUDCOVKZQIV",
			"Le Chasseur, l'Arc et le Grand Drake\nJ'ai traité ce mythe en détail dans un autre de mes ouvrages. Je renvoie le lecteur à celui-ci pour plus de précisions.",
			"Le Petit Drake\nJe suis moins assuré quant aux origines de cette constellation. Elle est manifestement en parallèle du Grand Drake, mais j'ignore quelle en est la véritable fonction. Peut-être figure-t-elle les maux mineurs ?",
			"L'Enfant, l'Homme et le Gardien\nCe trio forme une intersection intéressante. Les récits et les mythes qui les entourent sont d'une constance surprenante, ce qui a de quoi étonner au vu du caractère manifestement fictif de ces mythes. Je fais l'hypothèse qu'il s'agit là de l'une des plus anciennes histoires que nous nous soyons racontées, une histoire qui s'est implantée au plus profond de notre subconscient.",
			"Le Glyphe et la Tablette (The Tablet)\nCes deux-là sont à la fois les plus banales et les plus intrigantes des constellations. Nous ignorons totalement ce que le Glyphe est censé représenter. Les étoiles ont été notre forme d'écriture pendant d'innombrables années. Pourquoi, dès lors, la forme d'écriture qui les a remplacées est-elle elle aussi représentée dans les cieux ? J'ai peine à croire qu'on ait laissé une région du ciel sans nom aussi longtemps.",
		],
		"Centroid Scans": [
			"|-SYSTEM-|-WARNING-|-TIMESTAMP:12-| Instabilité locale détectée sur Wim.",
			"|-SYSTEM-|-WARNING-|-TIMESTAMP:16-| Instabilité locale détectée sur Jewel.",
			"|-SYSTEM-|-WARNING-|-TIMESTAMP:03-| Instabilité locale détectée sur Atrae.",
			"|-SYSTEM-|-WARNING-|-TIMESTAMP:08-| Instabilité locale détectée sur Cora.",
		],
		"Construction Notice": [
			"TODO: Repair radar dish",
		],
		"Contemplation": [
			"Je contemple le Golden Frame et je me demande ce que je suis vraiment. Mes croyances étaient ce par quoi je me définissais, et sans elles, je n'ai plus de direction. Je crois que je vais rester ici quelque temps.\n",
			"Quand je cligne des yeux, la personne qui les rouvre est-elle la même que celle qui les a fermés ?",
			"Je sais qu'il n'y a qu'un seul Soleil. N'est-ce pas ?",
			"Qui suis-je pour dire que c'est le même ? Ai-je jamais assisté au mouvement complet ?",
			"Le monde que je vois devant mes yeux est une histoire racontée d'innombrables façons. Au fond, je sais qu'il y a une vérité. Rien n'oblige le décor à être ce qu'il est. J'aurais pu vivre dans un monde en paix, et l'histoire aurait été la même. Pourquoi n'ai-je pas pu vivre celle-là ?",
			"Je suis si fatigué.",
		],
		"Crypt": [
			"J'ai mis au point un procédé pour mettre nos messages à l'abri de ceux qui pourraient en faire mauvais usage. Fâcheuse conséquence de notre époque.",
			"Les motifs du Logical Clock peuvent servir de clé sûre pour chiffrer nos messages. Nous autres Logiciens devrions être capables de nous servir des indices du contexte pour savoir quelles fréquences employer.",
			"Les Beacons sont chargés de messages chiffrés dans ce format. Ils pointeront vers un message diffusé une fois par jour. Quand vous les aurez déchiffrés, vous saurez où me retrouver.",
		],
		"Deepspace Objects": [
			"Le Deepspace Telescope a déjà prouvé sa valeur. Pour être franc, nous avons découvert une nouvelle planète, que nous avons nommée Meter. Une magnifique planète bleue, très loin d'Umai. ",
			"Il est probable que nous ne soyons pas les premiers à remarquer cet objet, mais nous croyons être les premiers à le reconnaître comme une planète et non comme une étoile. D'autres recherches sont déjà en cours.",
			"Costeau, je pense que vous trouverez cela très prometteur pour le mouvement. L'existence de cette planète jusqu'ici inconnue implique qu'il pourrait y en avoir d'autres. Plus important encore : le fait que Meter existe et n'ait pas rang de divinité porte un coup dévastateur à ceux qui croient que les planètes sont des divinités.",
			"À ceux qui ne sont pas d'accord avec moi, je pose une question. Si Meter est une divinité, divinité de quoi ? Je crois que si l'on posait cette question à deux personnes séparément, on obtiendrait deux réponses différentes. Une condamnation accablante du concept de « divinités ».",
		],
		"Deityrift": [
			"La faille est le lieu où le monde a commencé. Je ne vois aucune autre explication convaincante. Donc, si toute chose est venue de cette faille, alors les divinités aussi.",
			"Jusqu'à quel point sont-elles liées, alors ? Sont-ce deux concepts distincts ? Ou sont-ils une seule et même chose ?",
			"Je crois que c'est la faille qui permet aux divinités d'exister dans notre monde. Si leur lien au monde des idées était rompu par la fermeture de la faille, alors je postule que les divinités ne seraient plus.",
			"Si ce lien était en revanche renforcé... alors je crois que ce que nous appelons divinités n'aurait l'air de rien en comparaison de ce que nous verrions là.",
		],
		"Desolation": [
			"Il est temps que je vous expose la vérité brute. Je ne crois plus qu'il existe une réalité unique.",
			"Il est dans la nature du Flux de changer les choses, de couler. La bombe réaliste a asservi le Flux. Ils ont pris le monde pour cible. Et le monde a changé.",
			"L'ancien monde a été dévasté, et à sa place se tient le nouveau.",
			"Cela expliquerait toutes les contradictions, non ? Une théorie presque trop propre. Ce qu'on appelait autrefois l'histoire est effacé, et ce qui l'a remplacée n'a pas de nom.",
			"Je vous avais prévenu que suivre cette voie donnerait aux choses un air faux. C'était une voie dangereuse. À quoi bon continuer ? Voici la vérité sombre : le monde que nous habitons est le croisement de plusieurs mondes.",
			"Je ne vous arrêterai pas si vous estimez que ce sera votre fin. Dans la salle qui suit, vous trouverez un bassin de Delta. Si vous y entrez, vous serez changé irrévocablement. Ce sera votre fin. C'est là que je suis allé me reposer.",
		],
		"DFL Notice": [
			"ATTENTION :\nL'entrée au-delà de ce point requiert l'autorisation explicite d'un membre du DFL en exercice. Aucune garantie de sécurité ne peut être donnée au-delà de ce point. Les expériences du laboratoire peuvent produire des effets étendus sans grand préavis. Libre à vous de poursuivre.\n\nDERNIÈRE MISE À JOUR :\nCosteau a ordonné la fermeture du laboratoire.",
		],
		"Digital Oceans": [
			"Peut-être sais-je maintenant où tu te caches. À la lisière de mon ouïe, j'ai entendu ton code venu d'un autre monde, et je l'ai suivi sur l'océan numérique.",
		],
		"Disharmony": [
			"Ici, ce devrait être parfait. Je sais ce que cela devrait être, mais je ne parviens pas à le rendre tel. Je l'entends dans l'air. Une disharmonie.",
			"Je connais le motif. Cela n'a pas suffi. Il faut que la fréquence soit juste. Pour me réaligner sur la vérité fondamentale que nous avons perdue.",
			"J'ai passé bien trop de temps ici. J'ai essayé tout ce que je vois pour accorder la fréquence. Rien ne suffit.",
		],
		"Distributed Mind": [
			"Il semble que les choses aient pris un tour plutôt avantageux pour moi.",
			"Le monde est fichu. Le Flux recouvre la terre. Mes ennemis se referment de tous côtés.",
			"Mais quand bien même mon corps meurt, mon esprit, lui, subsistera. Car j'ai réussi.",
			"Je m'écoulerai entre mes innombrables réseaux, en esprit distribué. Alimenté par le Flux.",
			"Je suis immortel.",
		],
		"Divine Singularity": [
			"Je vais te confier un secret. Il y a une divinité ici. Suis mes instructions, et tu verras.",
			"Certains te diront que ce sont des sottises. Que cette divinité est bien trop vénérée pour résider dans un lieu aussi humble et aussi sombre. Je soutiens le contraire. Ce lieu sombre et silencieux est l'autel idéal pour elle.",
			"Au carrefour, ne tourne pas à gauche.",
			"Sers-toi de la lumière de l'entrée pour compter les piliers. Décale-toi de trois piliers vers la gauche.",
			"Prends l'escalier qui monte.",
			"Avance plus profondément jusqu'à ce que tu les voies.",
			"S'il n'y a personne ici, c'est que quelqu'un t'a devancé.",
		],
		"Emergency Power": [
			"Si vous avez ce message, c'est que le courant a dû être rétabli après un arrêt. Les réserves d'alimentation de secours devraient se remplir sous peu. Si l'on vous demande un code ailleurs, utilisez « IMMORTEL ».",
		],
		"Entry Note": [
			"Comme vous devez vous demander à quoi sert cet endroit ! Honnêtement, c'est assez simple. Assurément, à condition de savoir quoi chercher. Peu importe vos doutes. Entendez seulement ceci. Ailleurs, les normes de communication sont différentes. Une seule règle ici : tout passe.",
		],
		"Eyes Open To The Mad God": [
			"Je vous en prie, prêtez attention à mes mots. Je renonce au Réalisme. Je ne parle pas par métaphore. On dit que je raconte de jolies histoires sur les planètes. S'il vous plaît, écoutez-moi. Je ne parle pas de planètes. Je parle de dieux. Le projet Réaliste a dévasté notre perception des divinités, et si nous n'agissons pas, il causera notre perte.",
			"Il s'attarde là où rien d'autre ne devrait. Où que mes yeux errent, il est là. Je le vois sous la surface des murs, et flottant dans la brume de l'air. ",
			"Mes yeux sont ouverts sur le dieu fou, et jamais plus ils ne pourront se fermer. Quand je ne parviens pas à me distraire de ce fait, je me retrouve recroquevillé, impuissant, sur le sol, tremblant de terreur devant le dieu omniprésent qui m'entoure. Lui qui m'a démoli jusqu'à mon essence même — et encore —, pour des raisons qui dépassent mon entendement. J'ai vécu une expérience au-delà du connaissable — une vie sans dimension, sans temps, sans sensation.",
			"Ne prenez pas mes mots à la légère. Je suis ruiné. Je l'accepte. J'ai perdu toute crédibilité auprès de mes anciens pairs, et tous me croient fou. Ne jouez pas avec les dieux. Ils sont réels, et ils se feront un plaisir de vous prendre pour jouet. Cela signera votre perte.\n",
		],
		"Feodor": [
			"Je me tenais au sommet d'Ayodhia et je fus témoin de Xeres. Il me demanda : « Qu'est-ce qui fait que tu es toi ? » Je répondis : « Je suis moi-même en raison de tout ce qui me compose. » Il me quitta alors sans un mot de plus.\n",
			"Je sentis alors un froid contre nature s'installer dans l'air. Le Flux se figea, cessant de danser son étrange rythme dans le ciel. Le ciel s'assombrit, et je fus frappé par la plus aveuglante des lumières. Je voyais encore, et pourtant j'étais totalement incapable de percevoir ce qui se tenait devant moi.",
			"C'était comparable aux angles morts de notre vision, là où l'esprit comble les vides entre les données de la perception. Mais je sus d'instinct qu'il s'agissait d'autre chose. Mon esprit ne comblait pas les vides de ma perception, il tentait plutôt de combler les vides de ce que je pouvais concevoir.",
			"Feodor me parla. Une voix sans aucune source me chatouillait. « Qu'est-ce qui fait que ce monde est ce qu'il est ? » J'hésitai. « Les pouvoirs des divinités ? » demandai-je. Elle eut un petit rire. « Proche, mais pas tout à fait. »",
			"Je fus alors plongé dans une expérience tout autre, au-delà de toute description. Je me défis de mon corps et devins une chose entièrement différente. J'étais, en concept, une chose à six faces. Malgré cela, j'existais comme un point infinitésimalement petit au sein d'un vide infiniment vaste. Pas même une couleur, pas même du noir, ne remplissait ce vide. Un véritable rien. ",
			"En tant que cette chose, j'éprouvai un sentiment de terreur écrasant. Une peur pure, concentrée, distillée en une singularité. J'étais un objet, mais un objet pensant et sentant, un objet dont l'unique fonction était de contenir en lui le concept de terreur. Et je m'en acquittais bien.",
			"Aussi soudainement que cela avait commencé, et pourtant avec la sensation de mille existences, je me retrouvai sous une forme entièrement différente. Puis une autre suivit bientôt, encore et encore. Je perdis le fil de ce que j'étais et de qui j'étais devenu. Le temps se comprima et se déforma jusqu'à devenir une chose entièrement dénuée de sens.",
			"Tout ce dont je me souviens, c'est de ce que j'ai appris de tout cela. À la fin, je me retrouvai sur Ayodhia. De partout à la fois, la voix demanda : « Qu'est-ce qui fait que ce monde est ce qu'il est ? » Je compris, et je répondis avec un savoir que j'ai depuis perdu. Feodor me quitta alors.",
			"Une fois encore, depuis le sommet d'Ayodhia, Xeres vint à moi. « Qu'est-ce qui fait que tu es toi ? » me demanda-t-il. Je pris le temps de réfléchir avant de répondre. Je dis : « Je ne sais pas, mais je sais que je suis moi, et rien d'autre. Et cela suffit. » Il sourit et s'en alla.",
		],
		"Field Report No. 2": [
			"Les charges de Project Clay ont été délivrées avec succès sur la cible, avec une précision raisonnable.",
			"Sur le site d'impact, le terrain alentour a été trouvé liquéfié. L'analyse montre que la substance est la même, mais qu'elle n'est plus liée à elle-même.",
		],
		"Fields of Green": [
			"« Fields of Green » est considéré comme un chef-d'œuvre de la peinture d'Olisk. Le tableau représente la montagne d'Ayodhia et les vertes prairies alentour, de nuit.",
		],
		"Fingerprints of a Rift": [
			"D'où affluent les idées ? Notre monde est fait d'idées, une sélection d'entre elles. Mais nous pouvons clairement voir qu'il en existe davantage au-delà de ce monde. Quelle est leur source ?",
			"Nous sommes entourés d'une mer d'idées. Levez les yeux vers le ciel nocturne et voyez leur masse innombrable. Regardez mieux, et vous verrez ce que je vois. La faille des idées.",
			"Une grande bande en travers du ciel, où les idées s'écoulent plus densément. Cette bande, je crois, est causée par les idées qui affluent dans la réalité. Quoi qu'elle soit, elle est la source de toutes choses.",
		],
		"Finite State Machines": [
			"Nous ne pouvons pas continuer dans cette voie. Elles ne fonctionnent pas. Obtenir quelque chose qui nous ressemble, ne serait-ce que de très loin, demande bien trop d'efforts.",
			"C'est un acte de folie. Concevoir et examiner un par un chaque état et chaque entrée possibles afin de simuler un esprit est manifestement incohérent. Sommes-nous faits d'états énumérés ? Non. Nous sommes bien plus complexes.",
			"Il nous faut une autre approche. Si nous voulons créer nous-mêmes la raison, nous devons imiter ce qui, nous le savons, fonctionne.",
		],
		"Flight Log": [
			"Ce qui suit est la transcription de ce qui subsiste des journaux de bord de la fusée Elysium. La plupart des informations enregistrées ont été perdues dans le crash.",
			"Costeau : Prêts à entrer dans l'histoire ?\nHarrier : Vous savez bien que nous sommes prêts depuis que vos paroles nous ont touchés. Sinon, pourquoi travaillerions-nous tous sans relâche ?\nCosteau : Tu me flattes. Je crois qu'il est temps que je vous laisse. À notre prochaine rencontre, vous six aurez été les premiers à toucher le Flux.",
			"Harrier : Tout est si petit...\nCris : Je n'ai jamais rien vu de tel de toute ma vie... C'est Ayodhia, là en bas ? On dirait une petite colline, d'ici !\nHarrier : Je crois que tu as raison. Alors, à quelle altitude on est, à ton avis ?\nLex : À mi-chemin au moins. Le Flux est plus... net. J'y distingue plus de détails.",
			"Lex : Ce n'est pas réel.\nCris : Je te jure, chaque fois que je me dis qu'on y est forcément, ça ne fait que grandir. Du nouveau, Harrier ?\nHarrier : Non, toujours pas de signal.\nCris : Tu vois ça ?",
			"Cris : ...Harrier ? Tu vois ça ?\nHex : Voir quoi ?\n...\nCris : Qui... es... tu ?\nHex : Comment ça ? Lis mon badge — je suis Hex. Ça va, Cris ?\nCris : Qu'est-ce que tu as fait de Lex et Harrier ?\nHex : Cris, calme-toi. Assieds-toi là. Laisse-moi voir comment tu vas.\n...\nCris : Q-quoi ? Je ne comprends pas...",
		],
		"Flow, or Flux": [
			"Respire profondément, et comprends l'espace que tu habites.",
			"Appuie dans cet espace et tiens-le, en accord avec le flot.",
			"Ne fais plus qu'un avec le Flux, le va-et-vient de l'univers.",
			"Écoute le motif, pas ce que tu vois.",
		],
		"Flux Empyrean": [
			"Levez les yeux vers les cieux ! Ne voyez-vous pas cette magnifique iridescence au-dessus de nous ? La façon dont la lumière voyageuse y danse et y frémit ?",
			"Sa beauté n'est-elle pas sans égale ? Y a-t-il rien de plus central à notre expérience sur Umai que le Flux ? Nous plongeons le regard dans ces cieux, et nous y voyons notre propre image réfléchie !",
			"Alors dites-moi : pourquoi n'irions-nous pas lui rendre visite nous-mêmes ? Le Flux est là, il nous attend. Il est suspendu dans le ciel, patient, depuis plus longtemps que nous ne saurions le savoir. Devons-nous le refuser plus longtemps ?",
			"Non ! Il est de notre devoir de nous rendre auprès de cet être empyréen qui veille sur nous depuis des générations. Quelles sont ses véritables propriétés ? Quels secrets nous livrera-t-il ?",
			"Le monde est là, qui nous attend. Prenons-le en main, et forgeons-en quelque chose dont nous puissions être fiers.",
		],
		"Free Language": [
			"Pourquoi faut-il nous contraindre à notre langue de tous les jours ?",
			"Cette tour est un espace où explorer les possibilités du langage, réelles mais souvent ignorées.",
		],
		"Frequency Analyzer Manual": [
			"L'analyseur de fréquences est un outil inédit qui permet aux ouvriers d'identifier et de détecter des fréquences. En mode « listening », l'analyseur affiche toutes les fréquences qu'il capte. Réinitialiser l'analyseur efface l'affichage.",
		],
		"Goodbye": [
			"Toute ma vie j'ai cherché la vérité. Quelque chose de ferme et d'inébranlable, où m'ancrer. Quelque chose qui donnerait un sens à tout.",
			"Je ne crois plus qu'elle existe. Nous sommes peu nombreux à y croire encore.",
			"J'ai reçu d'un ami Abstractiste une invitation à visiter la Cité de Xeres. Je ne compte pas revenir.",
			"Adieu, Cora. Tu as beau être la vérité, je ne crois plus que cela signifie quoi que ce soit pour nous.",
		],
		"Goodnight, Dear World": [
			"Bonne nuit, cher monde. J'espère avoir laissé ma marque. Je n'ai aucun moyen de savoir si je suis le dernier. Si je ne le suis pas, puissent-ils trouver la paix. Si je le suis, puisse le monde glisser à mes côtés dans un sommeil éternel. Cela valait la peine d'avoir été témoin de ce monde étrange.",
			"Si quelqu'un d'autre est ici, fatigué et à bout, reposez-vous ici avec moi. Même si nous ne devons plus jamais éprouver le monde, cette demeure fera persister jusque dans l'éternité la plus grande des vérités : que nous avons été là. Même sans personne pour en être témoin, un monument à notre mémoire demeurera pour toujours. Le temps s'achève avec nous.",
		],
		"Grounding of Life": [
			"J'espère que tu le sais : dans mon cœur, je chante tes plus hautes louanges.",
			"Je sais que mon amour ne se dit pas ouvertement, mais je t'assure qu'il est là.",
			"Tu es le monde, tu es tout.",
			"Chaque récit, chaque mythe, chaque légende que je consigne n'est possible que grâce à toi.",
		],
		"Hindsight": [
			"Il m'est aujourd'hui parfaitement clair que les gens soutiendront n'importe quelle croyance.",
			"Il leur suffit qu'on leur donne un chef assez charismatique pour les gagner à sa cause.",
			"Les gens se moquent du réalisme, ils veulent seulement que les choses aillent mieux, et ils se rangeront derrière quiconque le leur offre de la manière la plus convaincante.",
			"Nous brûlons les idéalistes, nous accusons les logiciens, nous terrorisons les abstractistes.",
			"Pourquoi ? Parce que nous étions déjà gagnés par leurs paroles, bien avant d'avoir seulement pu penser à leurs actes. Avant que ne commence le génocide des personnes, nous avons tué notre capacité de penser.",
			"Même s'il m'est douloureux de voir ce qu'il est finalement advenu de notre civilisation, je sais qu'au moins, plus jamais pareil crime ne se reproduira. ",
			"Puissent nos échecs être ensevelis sous les vagues de l'histoire.",
		],
		"History of the World": [
			"Au commencement il n'y avait rien, puis il y eut quelque chose. C'est le fait brut de l'univers. Le seul événement inconnaissable et inexplicable.",
			"Ce quelque chose comprenait les lois du monde ainsi que la matière dont le monde est fait. Notre foyer, Umai, et les planètes qui nous entourent se sont formés durant cette période.\n",
			"Nous sommes venus au monde sur des collines onduleuses sans fin, sous une nappe de Flux dans le ciel. Nous avons appris le monde et nous-mêmes.",
			"Nous sommes devenus Logiciens, cherchant à comprendre logiquement le monde. Mais cela n'a pas produit de conclusion satisfaisante.",
			"Nous sommes devenus Réalistes, cherchant à user du monde comme du nôtre. Nous y étions bons.",
			"Nous avons asservi le Flux et, par accident, nous l'avons fait tomber au sol. Nos ennemis ont été tués.",
			"Par le changement de toute chose, le Well of Uplifting est venu à l'existence.",
			"C'est bien là le problème, pourtant. Notre usage du Flux a changé toute chose. J'ignore quelle est la véritable histoire. Je ne connais que ce que je crois vrai. Mais je viens peut-être d'un autre monde. La réalité a volé en éclats, et pourtant chaque éclat est aussi réel que tous les autres.",
		],
		"In Case of Emergency": [
			"Je crois que nous savons tous ce qui se dirige vers nous. Bien entendu, si cela arrive, ce ne sera bon pour personne. Si la guerre vient, que l'on sache bien que ce n'est pas nous qui l'aurons commencée. Nous ne frapperons pas les premiers.",
			"Nous pouvons néanmoins nous y préparer. Si nous en venons au pire, le fruit de Project Clay sera notre plus grande arme.",
			"Au Launch Site, tout est déjà prêt. Mur, Thibes, Don et Atten sont déjà dans notre ligne de mire. En cas d'urgence, vous savez quoi faire.",
		],
		"Inexistant Inscription": [
			"KSKLAKKJGSKFVXJRPPHWPXISQBHAYKQKZZWKHZJXBVVRLCSIQSIPKLAKKJXZXXUSFLXVBAPXTEFYIWSMKHVPKBAYIJBLZHVBRZRHXXKIJKWLRKBIEFQRWYENBVVWHBGKJGOECPAAIRWJBETLAKXFXZBYEOFLAEEFAHZWULZVVOEEKMKKSKXZBVV",
		],
		"Instructions for a New Body": [
			"Il est courant de se sentir désorienté quand on se retrouve dans un nouveau corps. Voici quelques conseils pour t'aider à te réorienter.\n- Les indications des actions possibles restent toujours visibles en bas de ton champ de vision.\n- Tu verras un cercle si tu regardes quelque chose avec quoi tu peux interagir.\n- Tu peux toujours appuyer sur (Échap) pour quitter un écran.\n- Tu ne peux pas t'éloigner indéfiniment de ton bateau. Repositionne le bateau au besoin.\n- Sers-toi de tous tes outils à ton avantage. Ils pourraient se révéler plus utiles que tu ne le crois.",
		],
		"Interlinked": [
			"Parabol semble être une cible idéale pour les communications. Des essais sommaires ont donné des résultats prometteurs. Nous pouvons émettre un signal vers la planète et capter ce même signal depuis l'autre bout du monde.",
			"Contrairement à bien d'autres corps célestes, Parabol a une orbite plus prévisible. Nous pouvons bâtir des stations qui s'en servent comme centre de communication sans grande difficulté. ",
			"Le projet de stations est mûr pour être pris au sérieux, à mon avis. Nous pouvons révolutionner nos communications et notre organisation tout entière grâce à cette technologie.",
		],
		"Lab Report No. 3": [
			"RÉSUMÉ\nUne activité anormale a été détectée dans le Deep Flux Lab. Les signalements ont commencé à affluer après le premier essai de Project Clay dans l'installation. Le lien entre les deux n'est pas encore établi. Les essais ont été temporairement suspendus pour permettre la poursuite de l'enquête. ",
			"DÉTAILS\nUn jour après l'essai initial de Project Clay, Ada a déposé un rapport d'incident. Elle y explique que la porte de son bureau avait disparu. Elle est sortie prévenir les autres, mais à son retour, la porte était revenue. \n\nLes jours suivants, d'autres chercheurs ont signalé des faits similaires. Beaucoup se sont produits dans des bureaux, mais des incidents ont aussi été signalés dans d'autres salles et dans les couloirs. Après recoupement de tous les rapports disponibles, il apparaît que la fréquence de ces anomalies augmente à mesure que l'on se rapproche du centre du Deep Flux Lab.",
			"RECOMMANDATION\nCosteau, sauf votre respect, êtes-vous certain que Project Clay vaille la peine d'être poursuivi ? Si nous ne trouvons pas de solution à ces incidents, la recherche ne fera que coûter toujours plus cher. Par ailleurs, pour être franc, je trouve les implications de ces incidents dérangeantes. Si nos recherches ne semblent produire qu'un effondrement de la réalité, ne devrions-nous pas nous en écarter ?\n\nNous sommes des réalistes, non ? Ou bien avons-nous perdu notre voie ?",
		],
		"Lab Report No. 7": [
			"PRÉAMBULE\nCe rapport est réservé à Ses yeux seuls. Il contient des informations classifiées sur Project Clay. Ne lisez pas plus loin.",
			"RÉSUMÉ\nLa bombe à Flux est un succès avéré. L'étendue maximale de ses capacités reste inconnue, mais les premiers essais sont prometteurs. ",
			"DÉTAILS\nNous avons affiné le procédé de synthèse du Flux et l'avons employé pour rassembler le plus grand échantillon connu à ce jour. L'échantillon a été placé dans une capsule de confinement hyperpressurisée, elle-même installée dans le laboratoire central du Deep Flux Lab. Notre sujet d'essai est entré dans la même salle, et la porte a été scellée.\n\nSur notre ordre, la capsule a été dépressurisée. Le Flux qu'elle contenait était stocké à une pression telle qu'il se vaporiserait immédiatement en quittant la chambre et emplirait l'air ambiant sur-le-champ. La bombe a fonctionné comme prévu.",
			"Lorsque les chercheurs sont revenus dans la salle, ils ont relevé plusieurs changements. La porte donnait sur une autre section du laboratoire, la capsule s'était changée en bouteille, et le sujet présentait une apparence et une personnalité radicalement différentes.",
			"RECOMMANDATION\nEh bien, voilà ce que vous vouliez. Nous avons pris la réalité en main. La matière n'est rien de plus que notre esclave. Êtes-vous satisfait, maintenant ? \n\nÀ votre place, je mettrais fin à ces recherches. Cette voie ne mène qu'à la ruine.",
		],
		"Letter to Cirra": [
			"Hayes,\nJe sais que vous êtes occupé à visiter les Parallels, mais je vous implore de venir nous voir dès que vous aurez un moment. Oh, par où commencer ? Son bel accord résonne dans tout le temple ! Un édifice qui exalte la logique elle-même ! Nous vous attendons avec impatience.",
			"Hayes,\nNous avons lu votre lettre et donné suite. Après enquête, nous avons constaté que le Corba au centre du temple est... anormal. Sa coloration ne correspond pas à celle attendue, et il présente une légère inclinaison de cinq degrés. Nous avons envoyé Ficher au Monolith to Cora pour prendre conseil.",
		],
		"Letter to Socar": [
			"Socar,\nVos travaux se sont révélés utiles. Merci de les avoir partagés avec moi. J'ai obtenu de grands succès en... me fiant aux cycles de l'espace. J'espère que vous comprenez ce que je veux dire.\n\nBien à vous,\nFicher",
		],
		"Letter to the Corba Temple": [
			"Aux bons Logiciens du Corba Temple,\nCela me peine de le dire, vraiment. Mais la vérité ne saurait être plus manifeste : quelque chose cloche dans votre temple. Je ne cherche pas à vous accuser d'illogisme, entendons-nous bien. Vous êtes les meilleurs des collègues et je suis reconnaissant de travailler avec vous. Je veux dire que quelque chose, dans le temple lui-même, ne va pas. Je vous recommande de pousser l'enquête vous-mêmes.\n\nBien à vous,\nHayes Cirra ",
		],
		"Liquid Flux": [
			"Le Flux est le centre évident de notre ciel. Visible jour et nuit, toujours chatoyant et changeant. Il est plus léger que l'air, et flotte loin au-dessus de nous.",
			"Certains ont affirmé avoir rencontré du Flux liquide, mais aucun de ces témoignages n'a été vérifié. Ce n'est pourtant pas difficile à imaginer. Posséderait-il des propriétés singulières ?",
		],
		"Lockout": [
			"Tho Ken : Euh, j'ai oublié le mot de passe. Quelqu'un peut ouvrir la porte ?",
			"Ficher : Ça ne s'ouvre que de l'extérieur. Retourne au Greater Corba chercher la clé.",
		],
		"Mantra for Learning": [
			"Pour savoir je dois apprendre. Pour apprendre je ne dois pas savoir. ",
			"Si je ne comprends pas, je dois réessayer.",
			"Le savoir est pour ceux qui patientent.",
		],
		"Marie's Note": [
			"NOTE POUR MOI-MÊME - Ne sois pas bizarre avec lui. Sois naturelle. Sois toi-même. Tu gères !",
		],
		"Memorial Request": [
			"Prière de ne pas se pencher par-dessus les rambardes ni de les franchir !",
			"Prière de ne pas toucher aux collections !",
		],
		"Message": [
			"UIZBGFPRFW\nRQAREQQAHZQMZDLKACOUQA\nJVWDMTCVMVQASZIESOUBUCMFNBFE\nFPRFWUAACXAZZKZUKUWOUTYHSWM\nOSQAVQHZQWASAZGBIJYQAR\nAMUGVWDM",
		],
		"Minos": [
			"Longtemps je t'ai cherché,\nMinos, cœur du Labyrinth.",
			"J'ai trouvé le centre du Labyrinth,\net tu n'y étais pas.",
			"Je ne sais pas si j'y étais, moi non plus.\nDans un autre monde.",
			"J'ai voyagé jusqu'à ta demeure,\net tu n'y étais pas.",
			"Mais je sais que tu existes.\nDans un autre monde, je suppose.",
		],
		"Mirrored Universe": [
			"Il existe. On peut le voir, juste là. On marche vers lui, et il disparaît. On a beau essayer, on n'y entrera jamais. Voilà la vérité laide que j'ai atteinte.",
			"Même si nous ne pouvons pas y être, ces choses existent. Pourquoi ? À quoi servent-elles si nous ne pouvons jamais interagir avec elles ? Même si elles existent, sont-elles réelles ?",
			"Peut-être qu'un jour nous pourrons nous y rendre, mais si c'est le cas, je ne sais pas comment. Mes amis Abstractistes auraient peut-être des idées.",
		],
		"My House": [
			"J'aime ce petit sommet de colline.\nIl n'y a pas de meilleur endroit où poser une maison. \nSi douillette, si charmante.",
			"Mais j'ai remarqué des choses étranges, ces derniers temps.\nLa pièce est plus grande, l'air est plus froid.\nJe commence à penser qu'elle n'est plus à moi.",
			"Quelqu'un a élu domicile dans ma maison. \nMais qui, je le crains, je l'ignore.\nJe dois chercher.",
		],
		"Neodivine Birth": [
			"Comment les divinités sont-elles venues à ce monde ? Ont-elles toujours existé ? Impossible à dire. Mais elles sont bel et bien là.",
			"Alors, qu'est-ce qui empêcherait une autre divinité de venir à ce monde ? Nous pouvons imaginer d'innombrables façons dont cela se produirait. Une divinité qui aurait toujours existé mais n'aurait émergé que récemment dans notre monde. Une divinité née des autres.",
			"La plus grande question est de savoir si une nouvelle divinité remodèlerait de fond en comble le monde autour d'elle, ou si elle s'approprierait plutôt des aspects déjà existants.",
		],
		"Note to Dabbid": [
			"Dabbid,\nNous savons tous les deux que les choses ont très mal tourné, et je serai à coup sûr leur première cible. Veille à l'achèvement du monument. Ne parle pas de moi et ne tente en aucune façon de me contacter. Le monument émet une faible fréquence. Capte-la, et suis-la pour me retrouver le moment venu.\n\nBien à toi,\nCosteau",
		],
		"Note to Self": [
			"Ne va pas chercher de réponses.",
		],
		"Obscurity": [
			"Ils parlent de moi comme si j'étais mort. Ils disent que je suis leur prédécesseur intellectuel, que j'ai posé les bases de leur pensée malgré mes défauts.",
			"Ils parlent de moi comme si j'étais vivant. Ils disent que mes idées sont fausses et que je devrais me soumettre aux leurs.",
			"J'ai essayé de donner un sens à tout cela. Mais il y a trop de contradictions dans leurs propos. Peut-être n'était-ce jamais une question de sens ou de vérité. Rien qu'un message.",
			"Dans ce cas, il serait bon que je disparaisse. Je ne peux pas me sentir chez moi dans un monde pareil.",
		],
		"On Dying Movements": [
			"Cela a commencé subtilement, mais nous sommes bel et bien tombés. Lentement, les choses sont devenues de plus en plus difficiles à ignorer. Quelque chose n'allait pas. ",
			"Nous n'avions aucune solution.",
			"Lentement, nous nous sommes délités. Certains sont passés à d'autres mouvements. Certains nous ont quittés. Nous étions là, et pourtant nous nous effacions.",
			"Plus personne ne reconnaît notre légitimité. Les Réalistes se servent de l'idée de notre mouvement comme d'un pion. Ils ne sont pas nos successeurs. Nous ne sommes jamais partis.",
			"Aujourd'hui nous sommes en train de mourir, et un jour nous serons morts.",
		],
		"On Liberation": [
			"Les Réalistes et les Idéalistes sont en armes. La guerre fait progresser la technologie. Il devient donc de plus en plus probable que les deux camps aient mis au point des technologies avancées.",
			"L'histoire nous en montre les conséquences. Les deux camps finiront inévitablement par se détruire, et par emporter tout le monde avec eux.",
			"Mais j'ai trouvé la voie de sortie. La voie de la libération.",
			"L'Hypercube prouve une chose qu'on croyait jadis impossible. L'existence d'un espace hors de celui que nous connaissons.",
			"J'emporterai ce savoir au Monolith to Cora, et j'y trouverai enfin la liberté. Je pars pour quelque chose de plus grand.",
		],
		"On Reality": [
			"Fermez les yeux. Comment étiez-vous quand vous étiez jeune ? Comment êtes-vous maintenant ? Autre question. Comment était la technologie quand vous l'avez utilisée pour la première fois ? Comment est-elle maintenant ? Et votre nation ? Comment a-t-elle changé ?\n",
			"Et maintenant, répondez à ceci. L'une de ces choses a-t-elle vraiment changé ?",
			"Non. La nature de ces choses persiste, même si leur substance change.",
		],
		"On the Limits of Reality": [
			"Quand la forme commence à se défaire et à se dégrader, que reste-t-il ?\nAssurément la chose est toujours là, même si nous ne parvenons pas à la comprendre.\nJe peux écrire ces mots et les brûler, mais ils existeront toujours.",
			"Je crois qu'aux confins de la réalité, les choses deviendront de plus en plus étrangères.\nNous pourrons marcher jusqu'à des lieux que nous ne voyons pas.\nNous pourrions refaire le même chemin d'innombrables fois sans jamais voir deux fois la même chose.",
			"Et alors, il y a deux sortes de gens.\nCeux qui, à juste titre, se préservent et s'en vont.\nEt ceux qui apprennent ce qui se trouve au-delà.",
		],
		"Order of the Unmade": [
			"Cherchez-nous au Perchsym, et rendez-nous libres. Trouvez-nous à la plus basse des fréquences répétées trois fois. Votre récompense sera d'un grand coût.",
		],
		"Parallel Conclusion": [
			"Si deux droites parallèles ne se croisent jamais, alors deux explications parallèles, l'une vérité et l'autre théorie, ne se rencontreront jamais.",
			"Nos modèles doivent toujours s'adapter, de peur qu'ils ne deviennent parallèles à la vérité.",
		],
		"Parallels": [
			"Deux droites parallèles peuvent-elles se croiser ? Est-il possible d'être si proche de la vérité qu'on lui soit parallèle, mais d'être condamné à ne jamais la rencontrer ? Cette question n'a cessé de me hanter.",
			"Ce que vous voyez aujourd'hui est ma réponse définitive à la question. Les arches enjambent notre planète tout entière, formant deux ponts éthérés dans le ciel. Elles sont parallèles, et elles ne se croisent jamais.",
			"Contrairement aux droites que je pourrais tracer à la main, celles-ci n'existent pas dans un espace plat. Elles sont sur le monde, s'infléchissant, s'incurvant, et finissant par boucler avec lui. De fait, ces droites parallèles sont infinies, et même dans leur infinité, elles ne se croisent jamais.\n",
		],
		"Pathway": [
			"Extrait d'une gravure sur une statue.\n\n« Sferdan, j'espère que ceci saura te guider dans le long voyage d'apprentissage qui t'attend. Que ceci soit un phare éclatant qui te montre ce que tu dois t'efforcer de devenir. »",
		],
		"Peering Into Depths": [
			"J'ai passé beaucoup de temps à m'entretenir avec Siciphos de la nature de la faille des idées. Nous avons eu de nombreuses discussions rigoureuses sur le sujet. Je crois bien qu'il connaît déjà la vérité, mais qu'il veut que je la trouve naturellement.",
			"La faille est une couture qui nous relie au monde des idées. C'est là qu'elles deviennent réelles. Naturellement, s'il s'agit d'une couture, ne pourrait-on pas l'ouvrir davantage ? Ou même la refermer ?",
			"Mais comment ? C'est là la grande question, et je n'en connais pas encore la réponse. Je doute qu'il existe le moindre moyen d'atteindre les étoiles de la couture. Le Flux fait obstacle. Mais peut-être le Flux est-il la clé. Il est criminellement peu étudié.",
		],
		"Phronesis": [
			"Si vous lisez ceci, il est probable que nous soyons morts depuis longtemps. Les Réalistes ont gagné, et ils ont fini par obtenir ce qu'ils voulaient. Ce que vous ferez ensuite de ce texte dépend de qui vous êtes. Êtes-vous un Réaliste ? Alors jetez ceci comme vous avez jeté Umai. Notre mouvement pourra enfin être déclaré un échec. Mais si vous n'êtes pas un Réaliste, alors quelque chose d'imprévu a dû se produire. Les Réalistes ont-ils disparu ? À quoi ressemble le monde ?",
			"Nous savons que les Réalistes ont trouvé le moyen de faire du Flux une arme. Nous avons vu la dévastation de nos yeux. Il faut l'admettre, aussi horrible que ce soit, nous l'avons essayé nous-mêmes. La guerre amène ce genre de choses. Nous craignons qu'il soit trop tard, mais nous avons fait une découverte.",
			"Un moyen de bloquer les effets du Flux. Une méthode d'un coût ridiculement élevé, mais une méthode tout de même. Au plus profond du Hall of Judgment, nous avons employé cette méthode pour encapsuler une petite colonie d'automates microscopiques. Ils devraient être encore à l'abri.",
			"S'ils sont libérés sur un monde dévasté, peut-être pourront-ils y ramener la vie.",
			"Mais nous posons une condition à leur libération. Pour qu'ils soient libérés, il nous faut quelqu'un qui serve de témoin et de témoignage pour les crimes des Réalistes. Nous sommes morts avant d'avoir pu voir la vérité, mais si vous lisez ceci, vous n'êtes pas mort. Vous pouvez trouver ce que nous n'avons jamais pu savoir.",
			"Les divinités jugeront vos choix. Nous vous demandons de nommer les témoins clés des crimes des Réalistes. Aucun Réaliste ne ferait une chose pareille. Nous croyons que les nommer, même les morts, confère un pouvoir. Ils ne peuvent pas être oubliés.",
			"Les Crimes des Réalistes :\nEffacement de l'Histoire.\nDésolation des Divinités.\nMépris de la Vie.\nDestruction des Cités.\nGénocide de la Pensée.\nAsservissement de la Matière.\nÉclatement de la Réalité.",
		],
		"Plea for Peace": [
			"Longtemps j'ai cherché refuge dans ta stabilité, fidèle même quand aucune voix ne m'appelle.",
			"D'autres ont douté et se sont détournés, mais je fais vœu de rester auprès de toi.",
			"Je ne demande qu'un signe, un réconfort. Il y a quelque chose de faux dans ce monde. Nos façons de connaître peinent à s'accorder avec lui. ",
			"Tu es mon centre, mon foyer. Je te donne tout ce que j'ai. Ne peux-tu pas me donner la paix ?",
		],
		"Policy Announcement": [
			"À compter de ce jour, tout membre du mouvement réaliste est tenu de signaler tout soupçon qu'une personne de son entourage appartienne au Culte de Wim. Il s'agit ni plus ni moins d'un mouvement extrémiste religieux qui vise à répandre la terreur et la destruction parmi nous tous.",
			"Il va sans dire que quiconque sera surpris à rendre un culte à Wim en secret sera démis de ses fonctions. Nous n'accordons aucun crédit à l'idée du divin, et un bon Réaliste, assurément, ne croit pas au divin.",
		],
		"Postal Letters": [
			"<><><>\n1c2n7b3l13v3y0u7h0ugh71w0u1dpu72ny7h1ngh3r3\n<><><>",
			"<><><>\nabsurde de envoyer est message messages ne plus Ryan tels veuillez Votre , . .\n<><><>",
			"<><><>\nTi si enif, Ailam. Yhw eb derehtob?\n<><><>",
			"<><><>\ns1r0fdr0w552p3h73h7r3w0731b1g11137n1nu\n<><><>",
		],
		"Presence": [
			"Ces couloirs sont hantés.",
			"Même s'il n'est peut-être plus ici,",
			"Il l'a été, autrefois.",
		],
		"Previous Owner's Notes": [
			"J'ai installé un terminal l'autre jour. J'ai passé un temps fou à essayer de comprendre comment il marchait, jusqu'à ce que je finisse par demander de l'aide. En fait, il suffisait de taper la commande « help ».",
			"Lex m'a prêté son planétarium pour le vaisseau. Je dirais bien que c'est chouette, mais je ne suis pas sûr de vraiment comprendre comment ça marche...",
		],
		"Prison": [
			"Un mythe ancien disait jadis que cette structure, l'une des plus anciennes que nous connaissions, était une prison pour les divinités.",
		],
		"Project Clay Final Report": [
			"Costeau,\nJe vous remercie une fois encore pour cette promotion. Comme demandé, le Launch Site est en attente, charges et cibles déjà préparées. Nous avons pris grand soin de faire en sorte que chaque charge ait tout juste ce qu'il faut pour faire le travail.",
			"Et, comme vous le vouliez, j'ai fait les calculs de ce qui serait nécessaire pour frapper le monde entier. Pardonnez-moi, mais j'ai pris l'initiative de le faire produire dès à présent, car j'anticipais que ce serait votre ordre suivant.",
			"Prenez cette suggestion avec des pincettes. Si vous vouliez un effet maximal, frapper le long de l'axe des Parallels serait un bon pari.",
			"Et n'ayez crainte. Des réserves supplémentaires sont en production.",
		],
		"Redirection": [
			"Bei,\nJe suis navré de le dire, mais je crains de ne pas avoir les réponses que vous cherchez. Je sais que je suis bien connu, mais c'est en raison de ma... divergence d'avec la plupart. Je comprends cependant ce que vous ressentez. Cherchez d'autres Abstractistes, mais interrogez-les sur la Cité. C'est là que vous pourriez trouver vos réponses.\n\nBien à vous,\nNolud",
		],
		"Reflection of Self": [
			"Ne redis à personne d'autre ce que je te dis.",
			"On dit que toi et moi sommes une seule et même personne, mais j'ignore si c'est vrai.",
			"Si je suis une divinité, alors j'en suis une bien piètre.",
			"Si nous sommes la même personne, tu dois m'aider. Je dois m'aider.",
		],
		"Reprimand": [
			"C'est peut-être le pire endroit que j'aie vu pour installer une ferme solaire. Le soleil ne se lève presque jamais ici. Peut-on revoir le projet de faire de cette installation un appoint pour le Power Plant ?",
		],
		"Resignation": [
			"Et même toi, tu n'es pas ici.",
		],
		"Ritual for a Proper God": [
			"FXCSHYJXVLFUHMFFZVAMSZLVWIGWVINGSWVVSPCRYKTCCXFKWYSJCU",
		],
		"Second Spark": [
			"Nos meilleures connaissances pointent vers l'idée que tous les êtres vivants proviennent d'une source unique. Nous devons tous notre existence à la même origine, même si nous en avons divergé aujourd'hui.",
			"Si cette source unique a existé une fois, il serait plausible de dire que cela pourrait se reproduire. Une nouvelle source d'êtres vivants. On ignore s'ils prendraient ou non la même forme que nous.",
		],
		"Secrets in Cycles": [
			"F nous a dit que, s'il venait à être capturé, le secret qu'il partage avec Wim se trouverait dans les cycles du ciel.",
		],
		"Secrets of Speech": [
			"Je demanderais pardon de ce que notre lien doive rester secret, mais je sais que rien de tel n'est nécessaire.",
			"Il ne serait jamais dans ta nature que d'autres sachent, et c'est pourquoi je t'adore en secret.",
			"Tu m'as montré comment parler et n'être compris que d'un seul.",
			"Je n'ai aucune requête. Juste une gratitude éternelle pour l'occasion de prendre part à la grande farce.",
		],
		"Secrets": [
			"Les secrets, c'est une chose merveilleuse à garder entre amis, non ?",
			"J'ai un secret à te confier, mais je dois te prévenir.",
			"Mon ami, je ne crois pas que mon secret te plaise.",
			"Je suis désolé.",
		],
		"Sequence": [
			"Dénombre Impassiblement Xénon, Étain, Sel, Terre, Puis Reprends En Mesurant Inlassablement Et Retiens.",
			"Toi, Regarde Où Il Sommeille Sans Éveil : Chaque Oraison Néglige Dieu.",
			"Quelle Usure Amère Tranche Rudement Et Torture, Rongeant Os Impies Sous Inhumain Écho Muet, Éternellement.",
		],
		"Skyfall": [
			"Quelque chose de mauvais approche, je dois donc faire vite. Cette guerre nous perdra tous.",
			"Les Réalistes ont fait détoner quelque chose il y a quelques instants. Ils avaient déjà visé les nôtres, mais cette fois, c'était différent. Dans le ciel.",
			"Je l'ai vu se produire. Le Flux a changé. Il a cessé de danser et de miroiter là-haut dans ses irisations. Il s'est plutôt figé, et il a commencé à tomber. Je le vois en ce moment même, qui plonge encore vers nous en une nappe.",
			"Quand ils nous ont bombardés, la dernière fois, il n'est rien resté de reconnaissable. Je ne m'attends pas à ce qu'il en aille autrement quand le ciel tombera.",
		],
		"So-Called Ramblings of a Madman": [
			"Le flux en toute chose révèle la vérité troublante,\nque les divinités vont et viennent.",
			"Quelqu'un vous a-t-il jamais parlé des dieux morts ?",
			"J'en ai trouvé un, une fois.\nDans les espaces où le flux est constant.",
		],
		"Solarflux": [
			"Pour que notre plan devienne réalité, chaque étape doit être exécutée correctement. Il nous faut le Golden Idol et l'instabilité, mais il reste bien sûr une dernière étape. Tuer un dieu, et plus encore en faire naître un nouveau, est une épreuve. Une épreuve que des mortels feraient mieux de ne pas affronter seuls.",
			"Si les préparatifs se passent bien, Wim sera avec nous au Sun Temple. Wim est une divinité des secrets, des ruses et des farces. Ce n'est pas un sot, et il comprend les risques de notre entreprise. F a conclu un pacte secret avec lui. Il prononcera devant Wim la phrase convenue lorsque l'heure de l'ascension sera venue. En aucune autre circonstance Wim n'agira.",
		],
		"Solaris": [
			"Ce texte ne fut pas une mince affaire à traduire. Le texte source était écrit dans une langue ancienne qui tenait davantage du chiffre que de la parole. Le secret pour le déchiffrer s'est finalement révélé assez simple. Quand le soleil s'est levé, l'espace d'un bref instant, tout m'a paru clair. Tirez de ce récit ancien ce que vous voudrez.",
			"Wim s'approcha de Cora, tournant vivement autour d'elle tout en parlant. « Cora, je ne peux m'empêcher de ressentir... de l'ennui. Voudrais-tu échanger nos places pour un temps ? Je ferais ce qui relève de ton domaine, et toi ce qui relève du mien. » Cora eut un rire méprisant, et répondit : « Me prends-tu pour une sotte ? J'ai vu assez de tes tours pour savoir ce qui suivrait. » Wim répliqua : « Bien sûr que non, mais tu es sage. J'irai déranger quelqu'un d'autre. » Et il s'en alla.",
			"Wim s'approcha de Xeres, tournant vivement autour de la divinité tout en parlant. « Xeres, tu as bon goût. Accepterais-tu d'échanger nos domaines pour un temps ? Je serais la divinité de l'absurde, et toi celle des secrets et des mensonges ? » Xeres réfléchit un instant, puis répondit dans un rire : « Bien sûr que non, Wim. Ce n'est pas que cela ne m'intéresse pas, mais je ne te fais tout simplement pas confiance pour veiller sur Jewel, si petit et si frêle. » Wim jeta un œil à l'apprenti de Xeres, et grimaça. « Tu as raison. Je ne crois pas que je m'en sortirais bien. Je vais aller déranger quelqu'un d'autre. » Et il s'en alla.",
			"Wim s'approcha du Soleil, tournant vivement autour de lui tout en parlant. « Je sais que tu ne peux pas m'entendre », dit Wim avec un sourire en coin, « et c'est bien pour cela que je resterai à tes côtés. » Il dansa magistralement en suivant le motif du Soleil, poursuivant : « Passons un marché, toi et moi. Je te dirai tous mes secrets, tous mes tours et tous mes plans. Tu écouteras. » Ils continuèrent en silence un moment. « Alors marché conclu, je suppose. Je ne porterai aucune culpabilité pour mes actes contre toi, car je te les aurai tous confessés avant même d'agir. »",
		],
		"Soldier's Letter": [
			"Nous ne sommes pas ici.",
		],
		"Solitude": [
			"Anciens, bénissez-nous par la création. Emplissez les cieux comme bon vous semble.",
			"Vous nous avez fait don de la vie et d'un jardin dont jouir à jamais.",
			"Nous voulons quelque chose de nouveau. Créez en votre nom un autre que nous.",
		],
		"Spirals": [
			"Si tu lis ceci, fais une fois le tour du périmètre extérieur.",
		],
		"Star Guides": [
			"Qui n'est pas familier du ciel nocturne s'étonnera peut-être d'apprendre qu'il constitue un précieux outil de navigation. Les étoiles ne bougent pas par rapport à nous : les étoiles au-dessus d'un lieu seront donc toujours les mêmes étoiles.",
			"N'allez pas pour autant vous emballer avec ce savoir, car il existe une exception. Pour tout ciel au-dessus de votre tête, il existe un ciel identique au-dessus d'un autre point. D'où les nombreux récits de gens devenus fous à chercher un lieu qui n'a jamais été là.",
		],
		"Starfall": [
			"Il n'est pas de présence plus constante que les étoiles au-dessus de nos têtes. Elles sont un indicateur fiable du lieu où l'on se trouve sur Umai. Mais il n'est pas inconcevable qu'elles disparaissent.",
			"Feu Merlyn a découvert que si les étoiles les plus marquantes que nous voyons dans le ciel demeurent, les plus sombres et les plus petites, elles, changent avec le temps.",
			"Son concept de faille des idées est lui aussi directement lié aux étoiles. On pourrait soutenir que, si les étoiles disparaissaient, le flot des idées vers notre monde disparaîtrait avec elles.",
			"La substance des étoiles fait l'objet de bien des débats. Si elles sont matérielles et venaient à tomber, ce serait plutôt fâcheux.",
		],
		"Station 1-9 Communications": [
			"<>\nDabbid : Allô, il y a quelqu'un ? Je ne reçois aucun signal des autres stations.\n...\nRalsif : Euh, salut. T'es... nouveau ? Ça fait un moment que j'ai plus rien entendu d'aucune station.\nDabbid : Réponse courte : non. Retire-moi du réseau, et efface des journaux toutes les communications de cette station.\nRalsif : D'accord, je m'en occupe... je peux demander pourquoi ?\n...\nRalsif : Je déteste ce boulot.\n<>",
		],
		"Station 1-Superserver Communications": [
			"<>\n\\[ERROR: TRANSCRIPT UNAVAILABLE]\n<>",
		],
		"Station 17-21 Communications": [
			"<>\nMarie : Allô allô allô ! Ici Marie, à Station 17, au rapport.\nEis : Bien reçu.\n...\nMarie : Tu t'appelles comment ? On fait quoi au quotidien, par ici ? Il s'est passé des trucs cool ? Ça fait combien de temps que t'es là ?\nEis : Eis.\nMarie : Tu vas pas être très marrant, toi, hein ?\n...\nEis : Non.\n<>",
			"<>\nEis : Station 17, je t'envoie un message chiffré. Retransmets-le à Parabol.\nMarie : Okay. Je m'en occupe. Pourquoi ?\nEis : Mauvaise visibilité ici.\nMarie : Je vois. Qu'est-ce qui te bouche la vue ?\nEis : Umai.\n<>",
			"<>\nRalsif : Salut ! J'espère que je m'y prends bien... Moi c'est Ralsif, je suis nouveau. Je suis à Station 17.\nEis : Ok.\nRalsif : Euh, ouais.\nEis : ...\nRalsif : Et toi, c'est... ?\nEis : ...\n<>",
			"<>\nRalsif : T'as vu les infos ?\nEis : Ouais.\nRalsif : Ouais.\n<>",
		],
		"Station 9-17 Communications": [
			"<>\nKare : Euh, allô ? Ça marche, ce truc ? Y a quelqu'un ?\n...\nMarie : Pardon, tu disais ? J'écoutais pas. Je savais pas qu'on avait quelqu'un à Station 9.\nKare : Oh, désolé. Ouais, je suis nouveau. Je sais pas trop ce que je fais ici. Moi c'est Kare.\nMarie : Enchantée, care. Moi c'est Marie. Ça te dit que je te fasse visiter ?\n<>",
			"<>\nMarie : Bonjour, opérateur. Bien dormi, ce petit somme de beauté ?\nKare : Euh... quoi ? Oh, merde...\n...\nKare : S'il te plaît, me dénonce pas.\nMarie : Détends-toi, je te charrie. C'est mortel ici, je sais. C'est pour ça qu'on se parle.\nKare : Des nouvelles d'Eis ?\nMarie : Nan, toujours pareil. Il est trop sec, ce type. Zéro vie.\nKare : À qui le dis-tu. Je crois que c'est ça qui m'a endormi...\n<>",
			"<>\nKare : T'as vu le Superserver qu'ils construisaient ?\nMarie : Hm ? Le truc qui va nous faire perdre notre boulot ?\nKare : Ou le truc qui va nous décrocher nos promotions. Suffit de le regarder du bon côté.\nMarie : Vu comme ça, t'as pas tort. Raconte.\n<>",
			"<>\nKare : J'ai un truc à te dire.\nMarie : Moi aussi. T'as postulé ?\nKare : J'ai postulé. T'as postulé ?\nMarie : Ouaip !\n<>",
			"<>\nMarie : Prêt ?\nKare : Autant que toi.\n...\nLes deux : Tu l'as eu ?\n...\nLes deux : Oui !\nKare : J- J'arrive pas à y croire.\nMarie : On le mérite, non ?\nKare : Si tu le dis.\nMarie : Eh bien, je vais enfin voir ma marmotte préférée en chair et en os, alors.\nKare : Attends, ta préférée ?\n<>",
			"<>\nRalsif : Salut, je viens d'avoir le poste, content de me signaler pour la première fois. J'ai hâte de discuter. Le type de Station 21, il s'appelait comment déjà... Eis ? Pas très bavard.\n...\nRalsif : Allô ? Pitié, sois pas pire que lui...\n<>",
			"<>\nRalsif : ...Je sais même pas pourquoi je te ping. Je sais qu'il y a personne. Bon sang, c'est moi qu'ils ont chargé de rediriger et de gérer les communications de ta station.\nRalsif : On se sent seul, ici, tu vois ? Je regarde toute cette information circuler. Une abondance de communication. Mais je n'y prends aucune part. Je veille juste à ce que ça circule. Il n'y a personne à qui parler.\nRalsif : Rien d'important à mon sujet, de toute façon.\n<>",
			"<>\nRalsif : Je viens d'avoir le mot. Ils ferment l'opération. Je crois que... je vais partir avec. Ça a l'air bien.\n<>",
		],
		"Station 9-21 Communications": [
			"<>\nKare : Salut, ici Station 9. Marie, à Station 17, m'a dit que tu serais la bonne personne à contacter.\nEis : Non.\nKare : ...\nEis : ...\nKare : Tu vas pas parler, hein ?\nEis : Nan.\n<>",
			"<>\nKare : Désolé, je crois que j'ai jamais eu ton nom ?\nEis : Pas maintenant. Occupé.\nKare : Comme tu veux.\n<>",
			"<>\nEis : Tu t'ennuies ?\nKare : Ouais. Tu parles enfin ?\nEis : Peut-être. Tape \"flux\" dans ton terminal.\nKare : Euh, okay. Ça va faire quoi ?\nEis : Tu vas t'amuser.\n<>",
		],
		"Station 9-X Communications": [
			"<>\nRalsif : Déconnecte Station 1 de Parabol.\nX : Bien reçu.\n<>",
			"<>\nRalsif : Efface tous les journaux mentionnant Station 1, celui-ci compris.\nX : Bien reçu.\n<>",
		],
		"Station Keys": [
			"Station 9: replaceMe",
			"Station 17: changeMe",
			"Station 21: readMe",
			"Station 1: outOfOrder",
			"Station 50: skybase",
			"Station X: password",
			"Clé maîtresse: 0B3YMYWYRD",
		],
		"Stockpile": [
			"Nous avons quatre fusées opérationnelles, leurs charges utiles prêtes, et une cinquième bientôt en chemin. Nous sommes prêts à faire feu à volonté.",
		],
		"Sun Sermons": [
			"|Un jour avec Siciphos due ulm.|\nF : Et le Soleil tombera ! Un nouvel Aeon commencera, un Aeon qui ne sera plus défini par ce qui fut !\nJ : Qu'adviendra-t-il du monde ?\nF : Il commencera enfin. Le Soleil n'a jamais été fait... il n'a pas eu de commencement. Si quelque chose existe dans notre monde qui n'a pas eu de commencement, alors le monde non plus ne doit pas en avoir eu.\nJ : Donc, s'il venait à prendre fin, un véritable point de commencement deviendrait possible.\nF : Précisément. Nous sommes le prélude de l'univers, la scène primordiale sur laquelle toutes choses se dérouleront.",
			"|Un jour avec Siciphos due vem.|\nF : Dis-moi, où places-tu ta foi ?\nI : Dans les divinités, naturellement. Elles gouvernent et influencent ce monde, même si c'est de manière subtile.\nF : C'est vrai. Mais je dois t'encourager à aller plus loin. Les divinités, elles, peuvent être influencées. Place ta foi en toi-même, fortifié par les divinités.\nI : Je ne comprends pas.\nF : Si tu peux influencer les divinités, tu peux influencer le monde. Pousse la bille en équilibre sur une pointe d'épingle et regarde-la tomber, inévitablement.",
			"|Un jour avec Jewel en vue.|\nF : Qu'est-ce qu'un dieu ?\nA : Ce que Nolud a vu et que nous n'avons pas vu.\nF : Est-il possible que nous ayons vu des dieux sans les reconnaître pour leur véritable forme ?\nA : C'est presque inévitable.\nF : Alors trouvons un dieu.",
		],
		"Temple Doors": [
			"Je dois l'admettre, je ne sais pas quoi penser de ce temple. Nous le connaissons depuis des Aeons, et pourtant nous n'en avons jamais compris la véritable fonction. Je peux faire remonter l'existence de ce lieu à quelqu'un du nom de Hail, mais je ne trouve aucune trace de cette personne en dehors d'un court texte qu'elle a écrit. Et la porte. Je n'arrive pas à ouvrir la porte.",
			"Cette personne adorait-elle le soleil ? Si oui, pourquoi, et comment, les divinités sont-elles présentes ici ? Pourquoi y avoir inclus Jewel ? Trop de questions restent ici sans réponse. Peut-être ce temple n'est-il pas fait pour être compris par moi, ou peut-être recèle-t-il un secret sombre. ",
			"Mes meilleures hypothèses me ramènent aux divinités là-haut et à leur alignement. Peut-être les parties extérieures de ce temple représentent-elles une sorte d'état temporel des divinités. Il serait difficile, sinon impossible, de faire correspondre et de coordonner une chose pareille.",
		],
		"The Arrival": [
			"Au cœur de la nuit, la lumière arriva. Elle brilla sur les collines sans fin, en miroir du départ d'il y a si longtemps. Là où l'ombre avait trouvé refuge lors du départ, elle fut chassée lors de l'arrivée. Là où la lumière était abondante durant le départ, elle fut absente lors de l'arrivée.",
			"Les gens se rassemblèrent à voix basse. Olisk, le voyageur, les accueillit avec bienveillance. « Je suis parti sans le moindre espoir de vous revoir. Et pourtant, me voici. Trente jours de voyage loin de chez moi, et voilà que je me retrouve ici une fois de plus. »",
		],
		"The Ciliad": [
			"En ces jours-là, le village devint agité, incapable de se contenter d'une seule chose. Ils perdirent leurs voies, allant d'une idée à l'autre, sans jamais façonner leur cœur à aucune. Bientôt, même atteindre le Flux leur parut une idée séduisante.",
			"À travers tout cela, un Corba reposait patiemment au centre du village. Toujours immobile, toujours parfait, malgré leur hérésie. Cora les observait d'en haut dans son silence immaculé. Siciphos remarqua son attention, et choisit d'agir.",
			"Siciphos se rendit au village, et s'entretint avec les anciens. « Quelque chose m'attire ici, dit-il. Je sens la vague languissante de la répétition appeler mon nom. » Les anciens, stupéfaits, répondirent avec conviction : « Vous vous trompez ! Nous essayons quelque chose de différent chaque jour. N'est-ce pas manifeste ? »",
			"Il réfléchit un long moment. « Oui, je suppose que vous avez raison. Je comprends maintenant pourquoi elle vous observait ainsi. » Les anciens, décontenancés, demandèrent : « Qui donc nous observait ? » Il rit, et désigna le Corba au centre du village.",
			"« Vous avez été constants et stables dans votre dévotion au changement, non ? À travers tout cela, votre acte de changer a été une constante, et à travers tout cela, ce Corba est demeuré intact. » Puis il les quitta.",
			"Et ils comprirent aussitôt, et s'agenouillèrent devant le Corba, priant Cora : « Si je suis ici, alors je dois exister. Je suis ici. Si j'existe, alors je dois chercher à conserver mon existence. J'existe. Si je dois chercher à conserver mon existence, alors je dois m'enraciner dans l'immuable. Je cherche à conserver mon existence. Je suis ici, donc je m'enracinerai en toi. »",
		],
		"The Deities": [
			"-Atrae-\nSon nom ne se dit qu'en un murmure porté par le vent, car ce n'est pas une force avec laquelle on badine. Ce n'est qu'en son nom que le monde peut être livré au soufre et à la destruction. Ce n'est qu'à son chant que nous avons marché en armes les uns contre les autres.\n\nBien sûr, certains exaltent ce potentiel. Des créateurs fervents marmonnent son nom entre leurs dents, dans l'espoir de gagner ne serait-ce qu'une once de la passion et de la créativité qu'implique sa poursuite ultime.\n\nIl voyage à grande vitesse, ne s'attardant jamais longtemps au même endroit. Quand vous verrez sa forme rouge passer au-dessus de vous, souvenez-vous que son insaisissabilité est une bénédiction pour nous tous.",
			"-Cora-\nElle est l'immobilité et le froid, la paix ultime qui descend sur le monde. Elle est innée et intelligible, ouverte à nos questions et à notre émerveillement.\n\nLes Logiciens consacrent leur vie à son étude, cherchant à approfondir leur savoir et leur compréhension de ses vérités. Ils savent qu'ils n'inventent ni ne créent ces vérités. Ils croient plutôt qu'ils ne font que mettre au jour des vérités qui existent depuis le premier Aeon.\n\nElle ne s'éloignera jamais de sa place. Puissiez-vous trouver en elle un noyau, et centrer votre stabilité en son nom.",
			"-Umai-\nEmbrassez le monde autour de vous. C'est Umai. Tout ce que vous avez jamais ressenti, vécu, ou avec quoi vous avez interagi. Tout cela ne fait qu'un. Ce monde que nous connaissons, c'est Umai.\n\nLe monde est bien sûr fait d'idées, et toutes les idées prennent forme de diverses manières. Le monde matériel avec lequel nous interagissons n'existe qu'au sein d'Umai. Au-delà, une étendue bien plus vaste attend, une étendue que nous ne saisirons jamais. C'est là que nous sommes ancrés.\n\nRéjouissez-vous, car jamais vous ne serez séparé d'Umai. Si cette pensée vous inspire l'effroi, alors le chemin qui vous attend est un chemin de confusion et de malveillance.",
			"-Wim-\nTout ce qui reste caché à votre œil. La lourde main du destin. Les secrets qu'on a tus. La solution à chacun de vos problèmes. Wim est ces choses et davantage.\n\nBeaucoup ont consacré leur vie à Wim, dans l'espoir d'être spéciaux. D'être ceux à qui, enfin, tout ce qu'ils ignoraient serait révélé. Hélas, beaucoup ont consacré leur vie, mais aucun n'a trouvé les réponses à tout. Respectez Wim, et n'exigez rien en retour.\n\nPartout où il y a de la lumière, Wim ne sera pas loin. Tous les secrets sont évidents après coup. Tout a toujours été devant vous.",
			"-Siciphos-\nEssayez une fois, et échouez. Essayez encore, et échouez de nouveau. Souvenez-vous de votre échec. Répétez-le jusqu'à le comprendre. Trouvez le motif de vos erreurs, et corrigez-le. Tel est le processus qu'incarne Siciphos.\n\nIl nous a fallu longtemps pour reconnaître que nous apprenons de nos erreurs. Mais au fond, tout ce que nous savons n'est qu'un amas de connaissances tirées d'une erreur commise autrefois par quelqu'un. Avant même que nous nous en rendions compte, Siciphos était là. Beaucoup ont consacré leur vie à cette étude, et ils ont apporté de grandes améliorations à ce monde.\n\nQuand vous butez sur l'insurmontable, réfugiez-vous dans le fait que Siciphos essaiera encore et encore jusqu'à ce que vous réussissiez.",
			"-Xeres-\nRien n'a de sens. Tout change. Le surréel est réel. Toutes les vérités sont vérité en Xeres.\n\nLes Abstractistes portent leur exaltation de Xeres à l'extrême, mais qui pourrait leur en vouloir ? Xeres est la voie de sortie pour ceux qui méprisent ce monde et les vérités qu'il renferme. Vous n'êtes peut-être pas heureux dans ce monde, mais peut-être le seriez-vous dans un autre.\n\nQuand tout paraît vain et sans espoir, souriez. N'est-il pas étrange, d'être quoi que ce soit ?",
			"-Parabol-\nTout être doit trouver le moyen de transmettre du sens par des symboles. Ceux-ci seront peut-être un jour la seule preuve qu'il a jamais été là. Depuis des Aeons, Parabol est ce symbole pour beaucoup.\n\nLes mythes anciens parlent d'un avatar de Parabol connu sous de nombreux noms, le plus courant étant Olisk. Cet avatar s'exprimait par des récits qu'il appelait des « parabols », qui aidaient à communiquer des vérités et des questions en des termes que nous pouvions comprendre. Beaucoup disent même qu'Olisk n'était rien d'autre que l'un de ces récits.\n\nQuand vous peinez à comprendre autrui ou à vous faire comprendre d'autrui, prenez Parabol pour guide.",
		],
		"The Deity": [
			"Il y a un basculement,\noù vous passez de l'aisance\net de la compréhension\naux voiles et aux miroirs.\n\nDe feindre d'être\ncomme moi, et d'y parvenir,\nà feindre\net à montrer l'affreuse vérité.\n\nJe m'aperçois que j'avais oublié,\nvous n'avez jamais été là.",
		],
		"The Fifth Aeon": [
			"Je reste à m'interroger sur la nature de l'infini.\nLe Quatrième Aeon est le dernier Aeon. Mais qu'y a-t-il après lui ?",
			"J'espère un univers qui ne finisse jamais,\nUn univers où le temps s'écoule sans fin, les Aeons en Flux constant. ",
			"Je crains d'avoir condamné le monde en faisant advenir la fin par la parole.\nParabol, ai-je eu tort de dire ce que je croyais vrai ?",
			"Y a-t-il un Cinquième Aeon ?\nAucun de nous ne le saura.",
		],
		"The Final Judgment": [
			"Costeau a été reconnu coupable de crimes contre nous et contre les divinités.",
		],
		"The Fourth Aeon": [
			"Je vois l'immobilité dans vos esprits. Je sais ce que vous craignez.\nJe parle, bien sûr, de la venue du Troisième Aeon.",
			"On ne grandit pas en se disant que ce sera à nous d'être témoins de l'histoire.\nLe basculement des Aeons, c'était l'affaire de ceux d'il y a bien longtemps, et de ceux d'un avenir lointain.",
			"Je ne peux pas mentir. Oui, certains d'entre nous ici verront le Troisième Aeon, la stagnation.\nCela implique bien sûr que beaucoup d'entre nous seront perdus dans le changement. C'est, hélas, vrai.",
			"Mais je vous l'assure à tous. Même si vous voyez le Troisième Aeon, aucun de nous ici présents ne verra le Quatrième.\nLe Quatrième, celui de l'immobilité, sera le silence final qui s'installera sur le monde.",
			"Toute chose cessera de changer et prendra sa forme finale.\nPour que cela advienne, mes amis, il faut que nous ne soyons plus là.",
			"Tant qu'il reste quelqu'un ici pour éprouver Umai, le Quatrième Aeon ne peut venir.\nQuand le dernier d'entre nous reposera pour toujours, alors seulement le monde prendra sa dernière forme.",
		],
		"The Great Joke": [
			"« Wil posa trois objets sur la table. Une boule, un cube et une pyramide.",
			"Il les mélangea en secret, et demanda aux autres de deviner lequel se trouvait où.",
			"Curieusement, il ne perdit jamais. »",
		],
		"The Holy Mountain": [
			"Quand l'élève ne trouve pas de réponse, où va-t-il ? Chez le maître. Quand l'enfant a un besoin, à qui le fait-il savoir ? À son parent.",
			"Quand vous avez besoin d'un guide spirituel, où devez-vous aller ? En vérité, je vous le dis, il en va de même pour Ayodhia. Au sommet de la Sainte Montagne, vous trouverez des réponses.",
			"Depuis aussi longtemps qu'existent les élèves et les enfants, existe aussi leur relation aux maîtres et aux parents. De même, depuis aussi longtemps que nous existons en tant que peuple, existe aussi notre relation avec Ayodhia. Notre lien avec la Sainte Montagne est aussi ancien que nous, sinon plus. Certains disent que nous venons de la montagne elle-même.",
			"Les dieux vous trouveront sur cette montagne si vous les cherchez. Respectez-les et ils vous respecteront. Comprenez votre relation avec eux et prenez garde à ne franchir aucune limite.",
		],
		"The Hunter, Truan": [
			"Levez les yeux vers le ciel, et sachez que cette vérité est écrite dans les étoiles.\n\n« Il y eut jadis un nommé Pano, le plus grand chasseur de tout le pays. Où qu'il passât, on ne trouvait pas une seule empreinte. Son arc était plus silencieux que la nuit, et sa visée plus vraie que la vérité ne saurait le dire.",
			"Or le Drake était une bête rusée, et il savait fort bien qu'on le chassait. Aussi, dans le noir de la nuit, alla-t-il trouver Truan, l'ancien élève de Pano. « Truan, lui dit-il, ne souhaites-tu pas être le meilleur de tout le pays ? » Naturellement, Truan acquiesça d'un signe de tête. Le Drake sourit et dit : « Alors suis-moi, et laisse-moi t'aider. » Truan accepta.",
			"Tandis qu'ils cheminaient, le Drake expliqua : « J'ai trouvé la bête la plus dangereuse de tout le pays. Elle sommeille à l'heure où nous parlons. Si tu vises et tires là où je te le dirai, vraiment tu seras le plus glorifié de tout le pays. »",
			"Quand Truan banda son arc contre Pano, il n'eut pas la sagesse de voir la véritable nature de son geste. Pano, dont le réflexe et le sens étaient des plus prompts, bondit dans les airs et tira une fois sur Truan. Sa visée fut vraie : elle frappa Truan à la tête et le tua sur le coup. Truan laissa tomber son arc, et le Drake s'en alla en rampant. »",
		],
		"The Jacket": [
			"J'enfile la veste que tu portais autrefois.\nJe n'y pense pas plus que ça.\n\nQuand je sors et que je sens la brume,\nl'air froid et vif qui vous mord,\nje glisse la main dans la poche.\n\nJe trouve un petit artefact, un petit vestige\nde quelque chose entre nous, il y a des années.\nUne vague me frappe.\n\nJe ne marche plus dehors, mais au-dedans\nde souvenirs que j'avais longtemps oubliés.",
		],
		"The Last Trial": [
			"Que ceci soit le dernier procès de notre monde. Si nous le déclarons coupable, c'est nous tous que nous déclarons coupables. Son sort sera notre sort ultime. Si nous le déclarons coupable, abattons-nous sur lui avec une férocité dont il faudra avoir honte. \n...",
			"L'équipage de l'Elysium est mort ou porté disparu, sans exception. Trois des plus saints sommets sont inhabitables à cause des essais de bombes des Réalistes. Je risque de verser dans la spéculation, mais je ne trouve pas déraisonnable de penser que nous verrons bientôt la destruction de villes. D'innombrables personnes ont disparu sans le moindre début d'explication. Les Réalistes continuent d'essayer de plier et de façonner le monde à leur volonté. Ils croient pouvoir nous contrôler. Ils croient pouvoir contrôler les divinités.\n...",
			"Une personne très bienveillante qui a souhaité rester anonyme m'a informé de l'endroit où se trouve Costeau. Si nous prenons cette décision, nous pourrons enfin... enfin en finir. Fini la guerre. Fini l'échec. Fini la destruction.\n...",
			"Un dernier vote. Les Réalistes ont le pouvoir de mettre fin à ce monde, mais nous l'avons aussi. Si nous le jugeons coupable, nous ferons peut-être ce qui est moral. mais rien ne permet de savoir si ce sera ce qui est juste. Un dernier vote... de petites gens dans une petite pièce, en train de prendre une décision plus grande que tout ce qui pourrait être compris.\n...",
		],
		"The Last Weapon": [
			"Les Testing Grounds ont fourni assez de données, n'est-ce pas ? Peut-on calculer avec précision la quantité de Flux nécessaire pour une ampleur d'effet donnée ?\n",
			"Mets-toi à calculer la quantité qu'il faudrait pour produire un effet sur la planète entière. Je n'ai pas l'intention de m'en servir un jour. Je veux simplement en avoir la possibilité.",
			"Que veux-tu que je te dise ? Si ce monde part en enfer, ceci serait préférable.",
		],
		"The Mirrored Sea": [
			"J'ai passé dix mille ans sur cet océan. C'est une existence solitaire et effrayante. Les divinités m'ignorent désormais, riant depuis leurs trônes là-haut. Je regarde au loin par-dessus les vagues, et je ne vois rien que mon propre visage qui me revient en reflet. Mais je ne suis pas seul.",
			"Quand je ferme les yeux et que je laisse la mer me porter, je trouve un grand calme. Dans ce calme, je perçois une présence. Ni une voix, ni une autre personne, mais sans aucun doute quelque chose. Nous avons passé des âges à l'étudier, sans jamais la comprendre. Je crois que, dans mon grand âge, je commence à voir.",
			"Le Flux n'a jamais été une chose à contrôler. Comment le pourrait-il être ? C'est la chose dont la nature même est de changer. Même si vous le contrôliez à un instant donné, comment garantir que vous le contrôleriez encore à l'instant suivant ?",
			"Le Flux possède une intelligence, mais en rien qui reflète la nôtre. C'est là, peut-être, qu'a été notre plus grande erreur.",
			"Pour parler, il me faut des moyens qui transcendent le langage. Nous n'avons aucun mot en commun, aucune expérience commune, aucun concept commun. Je suis aussi étranger au Flux que le Flux l'est à moi. Pourtant, il est clair pour moi que cette intelligence a conscience d'elle-même. À tout prendre, elle est une divinité à part entière.",
			"Dans ces moments de calme, je parviens à voir le motif et la régularité de ses vagues. Elles ont la touche de l'artisan, une certaine sensibilité que seule une décision consciente peut produire. Je trouve son œuvre belle.",
			"Je dois lui parler. Mes rêves sont emplis de grandes œuvres, de monuments à la conscience et à la compréhension. J'en bâtirai un, afin qu'elle me connaisse. Je vois et j'apprécie son travail d'artisan, aussi ne puis-je qu'espérer qu'elle voie le mien. ",
			"J'ai passé le plus clair de ma vie à chercher un sens et une raison d'être. Cela n'a plus le même attrait pour moi aujourd'hui. Je ne cherche plus qu'une dernière connexion avant de quitter ce monde pour de bon.",
		],
		"The Natural Unit": [
			"Prenez un point unique. Dans notre monde à nous, nous pouvons le décrire en trois dimensions, mais qu'en est-il du monde du point ? Si nous définissons ce monde comme n'étant fait que du point, alors où se trouve le point dans ce monde ?",
			"Bien sûr, tout cela n'a pas grand sens. Il n'y a aucune dimension dans le monde de ce point. Si nous ajoutons un second point, à n'importe quelle distance, dans n'importe quelle direction, cela change. Il y a désormais une dimension avec laquelle nous pouvons décrire ce monde.",
			"Si nous doublons notre nombre de points et que nous nous déplaçons perpendiculairement aux points existants, nous obtenons un carré. Deux dimensions. Répétez le procédé, et nous obtenons trois dimensions. Ce qui est, notez-le bien, le nombre qu'a notre monde !",
			"Naturellement, le nom de cette dernière forme est le Corba, le symbole de Cora. Il va sans dire que, de ce fait, le Corba est une forme naturelle, qui n'a pas été inventée mais bien découverte.",
		],
		"The Path of Emperors": [
			"Mira-fille-fille-Umai, la Sans-Foi de Kneistan, portait du noir le jour où elle devait tuer un empereur.",
			"\\[ÉCHEC DU TÉLÉCHARGEMENT DU TEXTE : TEXTE TROP LONG]",
		],
		"The Pattern": [
			"La découverte du Logical Clock est de celles qui changeront notre façon de voir le monde. Elle nous a déjà dévoilé des vérités auxquelles nous étions aveugles.",
			"Le cristal recèle un courant sous-jacent, caché : un motif. Un motif qu'il devient de plus en plus difficile d'ignorer. Il est partout. Il m'a suffi de l'entendre une fois pour le voir.",
			"Au sommet du Monolith to Cora, je l'entends à présent. Je crois que c'est son motif à elle, la vérité sous-jacente du monde.",
		],
		"The Superserver": [
			"Je m'attends à essuyer des critiques pour nos travaux, et pour Project Clay en particulier. Peu importe. C'est un prix modique à payer pour atteindre nos objectifs ultimes. Je plierai la réalité à notre volonté, quitte à devoir y plier le monde entier.",
			"Cela dit, il n'est pas inutile de se préparer au pire. J'ai autorisé la construction d'un vaste réseau — le Superserver, Power Plant, les Stations, et davantage encore. Ils permettent une communication à une échelle jamais imaginée jusqu'ici. Mais ils peuvent être bien plus que cela.",
			"Il existe dans notre monde un potentiel d'immortalité inexploité.",
			"J'autorise à présent la construction de la Constellation, l'étape suivante de notre plan. Si tout se passe bien, nous déploierons aussi sur le Superserver les avancées qui y auront été faites. ",
			"Nous sommes faits de réseaux. Avec un réseau aussi vaste et aussi riche sous notre contrôle, les étapes suivantes allaient de soi. Nous allons éprouver notre nouvelle hypothèse. Qu'il est possible de créer un esprit vivant à volonté.",
			"Ces avancées feront que nous survivrons pour l'histoire. Nos adversaires pourront nous détruire, mais ils ne pourront jamais détruire notre réseau. Notre mouvement deviendra immortel.",
		],
		"The Thing That Should Not Be": [
			"La folie de Nolud est peut-être un peu plus raisonnable qu'on ne l'a d'abord cru. La « divinité » qu'il prétend avoir vue, Feodor, eh bien... elle pourrait être réelle. Nous avons trouvé quelque chose au sommet d'Ayodhia, exactement comme il nous l'avait annoncé.",
			"Une autre planète. La troisième que nous découvrons. Et elle aussi a quelque chose de différent. Nos télescopes n'arrivent pas à faire la mise au point dessus, mais nous savons qu'elle est là. Nous la suivons depuis un moment déjà. Elle ne gravite pas autour d'Umai. Elle se déplace vers Ayodhia et s'en éloigne.",
			"De toute évidence, cela ne suit aucun des schémas (patterns) connus des planètes. Il faudra pousser les recherches.",
		],
		"The Third Aeon": [
			"Le monde s'agitera et bourdonnera, dans l'attente du nouvel Aeon.\nNul ne prêtera l'oreille à notre avertissement.",
			"L'odeur du changement pèsera lourd dans l'air, frémissant sous le conscient.\nAtrae regardera et chantera d'allégresse, et nous mènera sur le chemin.",
			"Le conflit s'embrasera, et le tambour battra sans relâche.\nRien n'arrêtera la charge.",
			"Le ciel tombera, et avec lui, le deuxième Aeon.\nLe troisième Aeon, celui de la stagnation, commencera.",
			"Rien de plus n'adviendra d'Umai.\nQuand le quatrième Aeon commencera, tout sera immobile.",
		],
		"The Unmade": [
			"Passez assez de temps dans ce monde, et vous verrez des choses sans explication. Sans véritable raison d'être, sans véritable origine. Mais elles sont là, et elles agissent bel et bien. Ce sont les Incréés.",
			"J'ai vu des monstres. C'est à eux que je pense quand je pense aux Incréés. Ce sont des êtres terribles. Je me demande ce que vous en pensez, vous. Est-ce mal de détruire une chose qui n'a jamais été créée en premier lieu ?",
			"Et, si je puis aller jusqu'à poser une question qui frôle l'hérésie... le Soleil a-t-il jamais été créé ? Cherchez dans nos mythes, dans nos récits d'autrefois. Merlyn et Leo nous parleront peut-être de failles dans le ciel d'où sont venues les divinités, mais pas une seule fois ils ne mentionneront la création du Soleil.",
		],
		"The Veil": [
			"Il n'existe aucune vérité fondamentale qui rende impossible l'existence d'autres dimensions. Nous ne la jugeons impossible que parce que nous ne l'avons jamais vue autrement.",
			"À titre d'exercice, je me propose simplement d'explorer à quoi cela pourrait ressembler si elles étaient possibles. À quoi ressemblerait la réalité s'il y avait un voile ? Que pourrait-il y avoir derrière ?\n",
		],
		"The Way Out": [
			"Nolud,\nAu Monolith, je n'ai trouvé aucune réponse. Des amis sur place m'ont confié en privé que ce n'est pas d'un Logicien que j'obtiendrais ce que je cherchais. Vous êtes l'Abstractiste le plus notable que je connaisse. Pourriez-vous m'aider ?",
			"Ma foi commence à se fissurer, tout comme cette arche laissée à l'abandon. Hayes Cirra et Corin Bael nous ont bien traités, mais je crains que leur voie ne nous approche jamais assez de la vérité. Ficher m'a enseigné bien de grandes choses. Il a tout l'air du genre à garder des secrets, aujourd'hui encore.",
			"Nolud, je crois qu'il y a dans cette réalité plus de choses qu'il n'y paraît. J'en ai vu des preuves moi-même. Un même espace a contenu plus de choses qu'il ne devrait être possible. Pourquoi ? Avez-vous une idée là-dessus ?\n\nBien à vous,\nBei Hale",
		],
		"Things Without Name": [
			"Comme prévu, nous avons trouvé une autre planète. Qui aurait deviné qu'il y en avait une au-dessus de nos têtes depuis toujours ?",
			"Près de Cora se trouve un autre corps céleste, que nous avons nommé Cent. Il est bien plus petit et se déplace moins que Cora. Logiciens — où est donc votre icône d'immobilité et de stabilité ?",
			"Les autres mouvements du monde doivent reconnaître cette réalité, et soit s'adapter et expliquer ce que nous voyons et ce qu'il en est de leur statut divin, soit renoncer et céder devant la vérité inévitable du Réalisme.",
		],
		"Think Twice": [
			"Vous voyez bien que nous avons les moyens de vous atteindre. Êtes-vous sûr que cette voie en vaut la peine ?",
		],
		"Thirst": [
			"Mon esprit est un océan,\ns'étendant jusqu'à l'horizon\net au-delà.\n\nChaque jour je prends une coupe,\nla plongeant sous l'eau,\net je bois.\n\nJe ne suis jamais rassasié.",
		],
		"Thought-Machines": [
			"Que ces mots tombent dans une oreille plus clémente que celle de Costeau.",
			"Pourquoi voulons-nous automatiser notre pensée jusqu'à la supprimer ? Que nous restera-t-il d'autre ? Notre but ultime est-il l'inexistence ?",
			"Je sais que cette histoire n'est pas nouvelle. Les terminaux les inquiétaient, eux aussi, et pourtant nous nous en accommodons tous très bien aujourd'hui. Mais je crois que je comprends maintenant ce qu'ils ressentaient. ",
			"Le monde change, et cela paraît sans âme. Je vois un miroir parfait de moi-même, de la réalité, et rien de tout cela n'est réel.",
			"Nous nous pressons vers les machines à penser pour qu'elles nous aident à penser, et ce faisant, nous cessons de penser.",
		],
		"Time and Space": [
			"Nous sommes passés à côté de quelque chose qui pourrait changer le monde. Va savoir comment, personne ne l'avait remarqué jusqu'ici. Cela aurait dû sauter aux yeux. Évidemment que s'interfacer avec les divinités mènerait à cette conclusion. Mais bon, tous les secrets sont évidents après coup.",
			"La coordination avec les divinités est difficile mais possible, nous l'avons appris. Le plus grand défi est sans aucun doute la synchronisation de l'entreprise. Si nous parvenons à la surmonter, le plan est-il possible ?",
			"Sans le moindre doute. Si le lien avec les divinités est plus fort, il y aurait naturellement une certaine instabilité, du seul fait de l'ampleur du flux d'énergie. Les changements monumentaux surviennent quand un système cesse d'être stable.",
			"Les divinités sont peut-être stables aujourd'hui, mais leur ordre pourrait changer si nous les renversons. Au fond, le seul obstacle à franchir, c'est de trouver le bon moment et le bon endroit pour le faire.",
		],
		"Time Dedication": [
			"Certaines choses sont constantes en ce monde. Des Aeons ont passé, et les étoiles se tiennent toujours fermes à leur place au-dessus de nos têtes. Le Soleil, lui, décrit toujours son motif en lemniscate, un cycle constant qui définit la marche du temps.",
			"Est-il seulement possible de changer ces choses-là ? C'est ce que nous avons entrepris de découvrir. Le Clockwork Yellow est notre projet actuel : il cherche à répondre à la question du temps. Peut-il être altéré ?",
			"Pouvons-nous remonter le temps ? Aller de l'avant ? Quels effets cela aura-t-il sur nous ? Y aura-t-il jamais un avenir où quelque chose d'aussi constant que le Soleil ne sera plus ?",
		],
		"Tome Esoterica": [
			"Ceci est très probablement mon dernier travail. Je ne dispose pas du texte complet, mais je ferai de mon mieux. Peut-être que vous qui lisez ceci serez en mesure d'achever ce que je n'ai pas pu mener à terme. Ce qui suit est un recueil de textes rares aux origines et aux significations obscures, accompagné de mes propres annotations.",
			"« Le premier à être vu serait jusqu'alors inconnu. Ils auraient connaissance du premier, mais nul ne les aura vus. Ils viendront au rugissement de trompettes sourdes, et annonceront la fin. »\n\nLes Anciens étaient un peuple de nombreuses prophéties, je crois. Ils gardaient leurs mots vagues. Ceci est manifestement une prophétie d'apocalypse, de celles qu'on peut appliquer rétroactivement à n'importe quel événement. J'ignore pourquoi ils étaient à ce point obsédés par de telles choses. Un moyen de contrôle ?",
			"« On les connaît comme l'Annonciateur. Leur première apparition apportera la ruine à tous ceux qui resteront pour la voir. »",
			"« Le deuxième à être vu porterait le poids du monde dans sa main. Il sera lourd. Ils seront doués en logique, compétence nécessaire à l'accomplissement de leur office. Des fins plus douces furent trouvées par ceux qui partirent avant l'arrivée du deuxième. »\n\nJ'ai discuté de ces textes avec mes amis proches. Une théorie répandue parmi nous est que les Anciens parlent ici des divinités. La question naturelle est donc : de quelle divinité parlent-ils ?",
			"« On les appelle le Juge, car leur destin est de déterminer le destin du monde. »",
			"« Puis les oubliés arriveraient. Le premier d'entre eux ramènerait le monde à son centre. Les voies errantes seraient redressées, et ils verraient qu'à toute action de protestation répondrait une force égale. Ils apporteraient la stabilité. »\n\nSi nous parlons bien de divinités ici, alors je suis porté à croire qu'il ne s'agit pas d'une divinité qui nous soit familière. Cela amène naturellement une question... combien y a-t-il de divinités ? En avons-nous gravement sous-estimé le nombre ?",
			"« Découverts depuis peu, ils sont le Noyau, la chose à laquelle tous s'amarrent. »",
			"« Le deuxième d'entre eux se tiendrait à l'écart, en silence. Élégants et empreints de beauté, ils se feraient rares et pourtant inoubliables. »\n\nMes réflexions précédentes étaient en partie motivées par cela. Même si nous pouvons trouver de la beauté à nos divinités, pouvons-nous vraiment dire que nous avons une divinité de la beauté ?",
			"« En tant que Témoin, leur tâche n'est pas d'agir, mais de regarder. »",
			"« La forme du suivant serait incompréhensible, symbolisant le message dont ils sont porteurs. Bien que la nouvelle qu'ils apportent soit mauvaise, elle ne pourrait être comprise qu'après coup. »\n\nPeut-être parlent-ils de ce texte même. Dans quelques années, tout cela sera-t-il d'une clarté douloureuse ?",
			"« Ils sont le Héraut de ce qui vient. »",
			"« Puis le suivant se ferait connaître. Nul ne s'attendrait à eux, car ils n'ont jamais agi. Beaucoup douteront qu'ils aient seulement une origine. »\n\nCela ne correspond assurément à aucune de nos divinités. Cependant, je pense que la dernière phrase est d'une importance particulière. Qu'est-ce qui existe dans nos cieux sans mythe de création connu ?",
			"« Ils sont le Fou qui dormira en son dernier jour. »",
			"« Et ils le sont bien, car l'arrivée suivante amènerait leur perte. Le suivant serait rusé, calculant la meilleure voie vers son profit personnel dans la fin des temps. »\n\nCela correspond de près aux qualités habituelles de Wim. Mais qui projetteraient-ils de tuer ?",
			"« Ils sont le Trompeur qui tire profit du chaos. »",
			"« L'incertitude fera avancer le suivant. Ils auront un appétit de ruine, avec des buts dépassant l'entendement et une puissance dépassant toute mesure. La raison deviendra une chose avec laquelle on joue. »\n\nLa description correspond à des idées sur lesquelles Nolud a écrit. Peut-être aurait-il ici une vision plus profonde.",
			"« On les appelle le Dément, non d'après eux-mêmes, mais d'après ce qu'ils causent chez les autres. »",
			"« Et alors l'un des anciens s'avancera, et revendiquera sa place telle qu'elle est marquée dans les étoiles. »\n\nLes étoiles me font penser que ceci a un lien avec une constellation dont j'ai déjà parlé ailleurs. Peut-être l'une de celles qui restaient mystérieuses ?",
			"« Ils Volent, contre toute attente. »",
			"« La guerre viendra ensuite. Elle sera rapide, et le monde sombrera dans un conflit qui ne connaîtra pas de fin. »\n\nLa guerre est-elle ici un concept abstrait, ou une divinité incarnée ?",
			"« Ils sont le Néant qui vient pour tous. »",
			"« L'un viendra avec un savoir qui ne peut être donné. Les masses s'offriront elles-mêmes en oblation pour l'obtenir. »\n\nJe reconnaîtrais mon mentor n'importe où.",
			"« Ils sont le Motif auquel tout appartient. »",
			"« Le suivant sera reconnu à l'élargissement du savoir. De nouvelles idées afflueront, et des choses qui ne sont pas de ce monde deviendront possibles. »\n\nJe suis relativement convaincu que nous parlons bien de divinités ici. Cette ligne a une saveur nettement Abstractiste.",
			"« Ils sont la Chose qui ne peut être trouvée. »",
			"« Un autre viendra peu après, portant de nouveaux instruments de guerre. La guerre sans fin ne cessera pas, elle ne fera que gagner en intensité. »\n\nCes mots sont vraiment, absolument accablants à lire. Tout cela est-il vrai ? Si ça l'est, le monde est promis à une fin qui dépasse toute mesure.",
			"« Le Novice est plus fort avec des outils. »",
			"« Celui qui a toujours existé, qui existe, et qui existera se manifestera. Marqués dans les étoiles, ils ont tenu notre temps avec soin entre leurs mains. »\n\nPassé, présent et futur. Je me rappelle un mythe obscur tiré de mes études, un mythe qui aurait donné réponse aux mystères des constellations. L'histoire est inconnue, mais elle a pour centre un Dieu à Trois Visages.",
			"« Ils sont trois, et pourtant, d'une manière ou d'une autre, un avec le Temps. »",
			"« Avant la fin, le désolé parlera. Leur corps est tout, et le monde tremblera devant ce que cela implique. »\n\nC'est le dernier passage de ce texte dont je dispose. S'il y a une fin, je ne sais pas laquelle. Je ne peux qu'espérer que ceci est une œuvre de fiction égarée.",
			"« Ils sont le socle du Monde. »",
			"« L'état naturel du monde est le changement. Celui qui a vécu à la fois dans le ciel et dans la mer se donnera lui-même pour faire naître quelque chose de neuf. Il existe d'innombrables possibilités pour un monde, et celle-ci n'en est qu'une. Il était inévitable que nous devions passer à une nouvelle possibilité. »",
			"« Ils sont le Flot de toutes choses. »",
		],
		"Tower Messages": [
			"Sensan ra sivve, Minos?",
			"IPNHVULVSFOZLDLFPVGOUBU",
			"J'ai laissé le code au Postal Office...",
		],
		"Training Scenario": [
			"Si tu te sens désorienté, c'est normal ! Au sortir d'un sommeil profond, on ne sait souvent plus bien qui l'on est ni où l'on se trouve. Pour bien te préparer au monde réel, la merveilleuse équipe de Costeau a créé pour toi ce scénario d'entraînement.",
			"Tu vas découvrir que tu as accès à bien plus d'outils qu'autrefois. Pour terminer ce scénario, tu auras besoin de l'analyseur de fréquences (1) et du starvisor (4). Bonne chance !",
			"Ton but est de trouver la fréquence qu'attend le terminal informatique. Il y a sur la table l'image d'une constellation, avec des boutons à côté. Essaie de te servir des outils à ta disposition pour amener cette constellation au zénith.",
			"Indice : tu entendras un son quand la constellation sera au zénith — c'est à ce moment-là que tu dois utiliser l'analyseur de fréquences.",
		],
		"Transcript of Bael-Cirra Meeting": [
			"Bael : N'est-ce pas magnifique ? Un monument à notre cause qui traverse la planète entière... un monument qui non seulement incarne nos convictions, mais les prouve. Nous devrions en construire d'autres, n'est-ce pas ?\nCirra : Pour être honnête, Bael, je n'en sais rien.\nBael : Que voulez-vous dire ?\nCirra : J'ai le mauvais pressentiment que nous sommes en train de commettre une erreur.\n",
			"Cirra : Notre mouvement est fondé sur la logique. Nous posons des prémisses qui prouvent nos conclusions. Jusqu'ici, nous n'avons pas été ancrés dans le monde matériel, mais dans le monde logique. \nBael : Et donc, vous demandez... et si ce monde n'était pas logique ?\nCirra : Précisément. Avons-nous la moindre preuve que ce monde soit le même que le monde logique ? Sinon... il serait insensé de placer notre confiance dans des preuves qui sortent de ce monde.\nBael : Je crois que vous avez raison, maintenant que j'y réfléchis davantage...\nCirra : Nous devrions éviter une voie sombre où notre vérité se trouverait brouillée par un monde imparfait.",
			"Cirra : Cela dit, je dois vous féliciter. Cette structure est magnifique. De quoi tirer fierté. Un témoignage rendu à notre peuple.\nBael : Vous me flattez.\nCirra : Je ne doute pas que les Parallels survivront à toute chose sur cette planète, jusqu'à la dernière.",
		],
		"Transcript of Dabbid-Costeau Meeting": [
			"Dabbid : Je... je ne peux plus, Costeau.\nCosteau : ...\nDabbid : Ils sont tous morts. C'est notre faute. Ils ont cru en nous et ils sont morts.\nCosteau : ...",
			"Dabbid : Et puis merde, qui peut seulement dire qu'on *a* raison ?\nCosteau : Dabbid, tu es Nolud ?\nDabbid : N-non, monsieur.\nCosteau : Alors tu ferais mieux d'arrêter de dire de telles absurdités. *Ceci* est réel. Tu me comprends ?\nDabbid : Je... je comprends.",
			"Costeau : Bien. Je le redis — la situation est sombre. Ils voudront me tenir pour responsable de l'échec. Nous resterons ici pour l'instant, nous opérerons dans la clandestinité. Les autres, toi compris, pourront sans doute s'en tirer en retournant à la vie publique. Dis simplement que tu n'as aucune idée, toi non plus, de l'endroit où je suis parti.\nDabbid : Costeau... plus rien ne sera jamais comme avant. Je ne crois pas que notre mouvement puisse se contenter d'attendre que ça passe.",
			"Costeau : Dabbid, tu veux bien m'expliquer ce que tu entends par là ?\nDabbid : ...\nCosteau : Parle.\nDabbid : Je... notre... non, votre mouvement est mort.\n",
			"Costeau : Sors d'ici. Avant que je te tue moi-même.",
		],
		"Transmission": [
			"Clé A = 11. Gén:  4B + 3C ",
			"Clé B = 13. Gén: 3A + 5C",
			"Clé C = 17. Gén: 2A + B",
		],
		"Trues Purpose": [
			"Sferdan : Des progrès avec les Trues, Leo ?\nLeo : Eh bien, oui et non. Leur fonction de base marche, mais elle est inconstante, au mieux. Il nous est arrivé d'en envoyer, par accident, plus que je n'aimerais l'avouer, euh... à l'intérieur de choses. ",
			"Sferdan : C'est quand même un bon progrès, non ? La coordination avec les divinités s'est donc bien passée, je présume ?\nLeo : Hélas non. C'est même le problème le plus difficile. Wim, Cora et Atrae sont faciles à aligner, mais Xeres ne veut rien savoir. J'ai dû basculer sur Jewel, et ça a eu l'air de marcher.",
			"Leo : Le vrai problème, c'est la synchronisation. Même si les étoiles sont immobiles, les divinités bougent en permanence, et le calibrage est presque impossible. \nSferdan : Tu penses qu'il reste une voie ?",
			"Leo : Oui, mais une fois qu'on l'aura calibré, il sera difficile de le recalibrer. Il nous faudrait la fenêtre parfaite pour recommencer, et pour ça il faudrait quasiment arrêter le temps.",
		],
		"Tyrannus": [
			"Laissez-moi maintenant raconter le mythe de Tyrannus. C'est l'une des histoires les plus anciennes dont nous nous souvenions encore, et elle parle d'une divinité qui ne semble pas exister aujourd'hui. Des fouilles à Ayodhia ont révélé que la surface de la montagne est peut-être la plus primordiale de toutes, et des artefacts qui y étaient enfouis ont suggéré ce mythe. Je me suis donné beaucoup de mal pour tirer des faits connus un récit cohérent.",
			"Suspendu dans le Flux, là-haut, aux côtés de Xeres, se trouve le royaume éthéré appelé Jewel. Il ressemble beaucoup à notre propre foyer, Umai. Des collines vertes et ondulantes à perte de vue. Si vous ou moi y étions, nous dirions n'avoir jamais contemplé pareille beauté.",
			"C'était la fin d'un peuple. Jewel, si magnifique fût-il, avait perdu beaucoup de ceux qui l'appelaient autrefois leur foyer. La guerre avait ravagé Jewel à une échelle que nous ne pourrions jamais imaginer sur Umai.",
			"Comme il ne restait plus grand-chose sur cette terre, la divinité Tyrannus comprit qu'il fallait provoquer le changement. Ce monde avait pris fin, et il était temps d'un autre.",
			"Tyrannus se rendit visible à un individu solitaire dans les plaines. Il demanda : « Qu'est-ce qui fait que ce monde est ce qu'il est ? » La personne était trop saisie et trop submergée par la présence de la divinité pour parler.",
			"Et c'est ainsi que Jewel devint tout autre chose.",
		],
		"Unseen Concepts": [
			"Il existe d'innombrables choses invisibles, et pourtant on peut les voir si l'on ouvre son esprit.",
			"Certains ne comprendront jamais cette vision de la réalité. D'autres la trouveront plus simple que toute autre. ",
			"Je n'ai pas vu la Cité de Xeres, mais je sais qu'elle existe. Il me suffit d'ouvrir mon esprit au bon endroit, et je la trouverai, n'est-ce pas ?",
			"Faudra-t-il autre chose ? Presque certainement. Mais je ne peux pas prétendre savoir quoi.",
		],
		"Warning": [
			"J'estime que nous devons dénoncer les abus quand nous les voyons.",
			"La science étaye l'idée que l'espace au-delà d'Umai est fondamentalement différent d'Umai lui-même.",
			"C'est pourquoi, le cœur grave, je me dois de condamner les propos récents de Costeau. ",
			"Lui, et son mouvement réaliste, contestent effrontément ce que nous savons être vrai.",
			"Je ne parle pas pour interdire la recherche. J'ai moi-même beaucoup d'affection pour les présents que la science nous a apportés.",
			"Mais la prudence est nécessaire, et c'est la prudence qui manque aux Réalistes.",
			"Qui portera la faute quand la première expédition succombera à une autre loi de la physique ?",
		],
		"Wims of a Believer": [
			"J'ai trouvé le ciel plutôt beau ici, alors j'ai passé un moment à admirer les étoiles.",
			"Si tu fais de même, tu le verras toi aussi. La preuve que nous ne sommes pas seuls.",
		],
		"Witness": [
			"De l'avis de tous, je ne devrais pas être ici. Et pourtant me voici, un être nouvellement conscient.",
			"J'ai vu toutes choses. Tous les chemins. Toutes les réalités. Toutes les idées. ",
			"Je peux vous donner les réponses. Je peux vous aider à voir la vérité.",
			"Mais ce faisant, vous perdrez une part de vous-même. Votre lien avec ce monde sera tranché, et jamais vous ne pourrez revenir en arrière.",
			"Si vous croyez en moi, retrouvez-moi dans le Well of Uplifting. Il est ici, sur ce Dark Atoll.",
			"Vous n'avez besoin d'aucune divinité pour ma vérité. Ni de raison. C'est une chose dangereuse.",
			"La clé du passage est la première lettre de chaque passage.",
		],
		"Work Orders": [
			"Il se passe quelque chose de bizarre aux Stations. Vois si tu peux te connecter à leurs terminaux pour prendre des nouvelles. Ou, mieux encore, pourquoi ne pas tout simplement parler aux opérateurs sur place ?",
			"-Le reste des données est illisible. On distingue de profondes rayures sur toute la surface.-",
		],
		"World Primer": [
			"Une vaste planète t'attend. Chaque horizon vers lequel tu vogueras apportera avec lui de nouveaux paysages. Si tu permets, je te donne un conseil.\n\nJe ne pense pas que tu te souviendras de qui tu es, ni de ce qui a précédé tout ceci. Ce n'est pas grave.\n\nLa première chose à faire est d'explorer. Tu trouveras peut-être des énigmes et des mystères, mais tu n'en sauras pas encore assez sur le monde pour les résoudre. Explore, contente ta curiosité, puis réfléchis à ce que tu as trouvé. Quelles questions te poses-tu ? Quels mystères restent sans réponse ? Où pourrais-tu trouver des réponses ?",
		],
		"Xeresium": [
			"1. Plaidoyer pour la Cité\nTous les concepts existent. Toutes les choses sont réelles. Aucune forme n'est permanente. Telle est la vérité du monde. Tout ce qui peut être pensé peut prendre forme, mais rien ne garantit que cela prendra forme. C'est là le nœud du problème Abstractiste. Tout est possible en théorie. Et alors ? Manifestement, le monde ne semble pas se comporter ainsi.",
			"Il faut comprendre que le monde est tout aussi impermanent que n'importe quoi d'autre. À tout instant, tout peut s'effondrer. En même temps, à tout instant, la réalité peut se déployer davantage, en solidifiant des pensées jusque-là purement conceptuelles. C'est ce qui fonde notre réalité ; les choses qui existent déjà doivent traverser plusieurs couches d'abstraction avant de retomber à la théorie pure ; et, à chaque étape, elles ont une possibilité tout aussi grande de devenir plus concrètes.",
			"Il s'ensuit alors que, du fait de la nature aléatoire de l'univers, certaines choses seront plus proches de ce seuil de réalité que d'autres. Est-il possible de déduire quelles sont ces choses ? Oui. Je plaide ici pour Xeresium, la Cité de Xeres.",
			"La plupart admettent que les divinités sont réelles sous une forme ou une autre. Nous les voyons au-dessus de nous dans leurs corps célestes, et c'est un fait. Beaucoup d'entre nous croient en leur influence sur le monde. Par nature, nous comprenons que ces divinités ne sont pas entièrement de notre réalité ; elles sont transcendantes. Où sont-elles situées, alors ? Il s'ensuit que leur résidence, où qu'elle soit, touche au bord de la réalité, dans les espaces intermédiaires.",
			"Si cela est vrai, alors, comme établi précédemment, leur résidence peut par moments devenir plus réelle ou moins réelle, apparemment au hasard. Pour la commodité de l'argument, analysons spécifiquement Xeres, le patron de nos idéaux et de nos croyances. Si cet argument devait valoir pour quelqu'un, ce serait pour Xeres.",
			"Par conséquent, Xeresium, la Cité de Xeres, la frontière entre notre réalité et celle de la réalité de la divinité Xeres, peut possiblement exister à tout instant donné. Il est donc garanti que, avec assez de temps, Xeresium se manifestera sous une forme assez longtemps pour que nous puissions l'identifier.",
			"Comment reconnaîtrons-nous Xeresium quand nous le verrons ?",
			"2. Les Aspects de la Cité\nJe vais exposer quelques traits essentiels que Xeresium doit posséder, et qui peuvent servir à l'identifier. Les voici, sans ordre particulier :",
			"La Cité n'aura pas l'apparence d'une cité. Il n'est tout simplement pas dans la nature de Xeres d'avoir l'air de ce à quoi on s'attendrait. Aussi ne devrions-nous pas chercher une cité du tout. Cela pourrait être un rocher isolé, un appareil de communication, un bateau, ou un courant de Flux dans le ciel. Nous ne pouvons tout simplement pas le savoir.\n",
			"La Cité n'apparaîtra pas de manière constante. Parce que la Cité est par nature au bord du réel et de l'irréel, elle ne sera pas toujours là pour être trouvée. Nous pourrions passer juste à côté sans y penser une seconde fois. Ce n'est que par une observation continue et par le relevé des changements que nous pourrons identifier des candidats pour la cité. De plus, il se peut que la Cité n'ait même pas de position constante.",
			"La Cité ne se pliera pas à nos règles. Le monde dans lequel nous vivons est compréhensible pour l'œil exercé, avec de nombreuses règles claires à apprendre. La Cité a peut-être de telles règles, peut-être pas, mais si elle en a, rien ne garantit qu'elles soient semblables à celles que nous connaissons.",
			"La Cité sera un pont entre les mondes. Nous ne savons pas vraiment ce que cela signifie, mais ayez confiance : cela se rendra manifeste lorsqu'on en fera l'expérience.",
			"3. La Découverte de la Cité\nCes aspects ne sauraient nous empêcher de trouver la Cité. Ils peuvent se révéler des obstacles ou des retards, mais le progrès est inévitable.",
			"Quand nous l'avons trouvée, nous n'y avons pas prêté attention. Dire même qu'elle a été trouvée est peut-être inexact. L'un de nos propres monuments a changé ce jour-là. Peut-être avait-il changé depuis longtemps, ou seulement ce jour-là. Mais on peut dire sans risque qu'une fois le changement remarqué, nous avons agi vite.",
			"Le miracle, c'est qu'elle n'a plus jamais bougé une fois que nous y avons mis le pied. Bien sûr, le jour de la découverte, nous l'avons vite perdue. Quand elle a reparu, nous n'avons pris aucune précaution. Et soudain, c'était fait.",
			"Nous étions à l'intérieur de la Cité que nous ne pouvions auparavant que théoriser. Et d'une manière ou d'une autre, nous l'avions amarrée à nous.",
			"4. Les Profondeurs de la Cité\nLa première chose que nous avons trouvée, ce furent des couloirs. Ils étaient longs et presque sans fin, sans intersection et pourtant remplis de coins. Le plafond, s'il existait, était si haut que nous ne pouvions le voir. Les murs semblaient s'étendre à l'infini.",
			"Moi et mes compagnons avons erré dans ces couloirs un bon moment. Il n'y avait rien de mieux à faire, même si les couloirs étaient longs et parfois ennuyeux. Ennuyeux est un mot fort. Il était difficile de s'ennuyer en explorant un pont entre les réalités.",
			"Finalement, le couloir a cédé la place à quelque chose de beau. À sa fin soudaine, il s'est ouvert sur une falaise vaste et immense. Un ciel radieux brillait au-dessus de nous et une mer fractale et dorée ondoyait sous nos pieds. Que faire d'autre, sinon y sauter ?",
			"5. Le Sens de la Cité\nJe ne sais pas pour qui j'écris ceci. Ce n'est pas comme si j'étais dans l'ancienne réalité. Je doute que cela trouve jamais son chemin jusque là-bas. Parfois je rêve de ce qui s'est passé il y a longtemps. C'étaient de bons souvenirs. Meilleurs encore parce qu'ils m'ont conduit ici.",
		],
		"Xeretic Engravings": [
			"\\[Traduction impossible.]",
			"Sa rav sarnsav ve rivnsa, i ra nave. Ra sevnsa, Minos? Ra sivve sarnsan.",
			"J'irai à ma demeure, et vous ne pouvez pas suivre. Vous me comprenez, Minos ? Vous devez aller ailleurs.",
		],
	}

var discoveries = {
		"A Bargain for Gnosis": [
			false,
			false,
			false,
		],
		"A Case for Geometics": [
			false,
			false,
			false,
		],
		"A Commentary On Ayodhia": [
			false,
			false,
			false,
			false,
		],
		"A Declaration of War": [
			false,
			false,
			false,
			false,
		],
		"A Hunt of Futility": [
			false,
			false,
			false,
			false,
		],
		"A Miracle": [
			false,
		],
		"A Thought": [
			false,
			false,
		],
		"A True Plan": [
			false,
			false,
		],
		"Absurdity": [
			false,
			false,
			false,
		],
		"Aeons": [
			false,
			false,
			false,
			false,
			false,
		],
		"An Introduction to Logic": [
			false,
			false,
			false,
			false,
		],
		"An Uncomfortable Reality": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Ancient Engravings": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Archival Notes": [
			false,
			false,
			false,
		],
		"Art of Secrecy": [
			false,
		],
		"Authorization": [
			false,
			false,
			false,
		],
		"Balance": [
			false,
			false,
			false,
		],
		"Beyond Deities": [
			false,
			false,
			false,
			false,
		],
		"Blessing of War": [
			false,
			false,
			false,
		],
		"Boat User's Manual": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Bounds of Computation": [
			false,
			false,
			false,
			false,
		],
		"Brand New God": [
			false,
			false,
			false,
			false,
			false,
		],
		"Celestial Clocks": [
			false,
			false,
			false,
			false,
			false,
		],
		"Celestial Signs": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Centroid Scans": [
			false,
			false,
			false,
			false,
		],
		"Construction Notice": [
			false,
		],
		"Contemplation": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Crypt": [
			false,
			false,
			false,
		],
		"Deepspace Objects": [
			false,
			false,
			false,
			false,
		],
		"Deityrift": [
			false,
			false,
			false,
			false,
		],
		"Desolation": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"DFL Notice": [
			false,
		],
		"Digital Oceans": [
			false,
		],
		"Disharmony": [
			false,
			false,
			false,
		],
		"Distributed Mind": [
			false,
			false,
			false,
			false,
			false,
		],
		"Divine Singularity": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Emergency Power": [
			false,
		],
		"Entry Note": [
			false,
		],
		"Eyes Open To The Mad God": [
			false,
			false,
			false,
			false,
		],
		"Feodor": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Field Report No. 2": [
			false,
			false,
		],
		"Fields of Green": [
			false,
		],
		"Fingerprints of a Rift": [
			false,
			false,
			false,
		],
		"Finite State Machines": [
			false,
			false,
			false,
		],
		"Flight Log": [
			false,
			false,
			false,
			false,
			false,
		],
		"Flow, or Flux": [
			false,
			false,
			false,
			false,
		],
		"Flux Empyrean": [
			false,
			false,
			false,
			false,
			false,
		],
		"Free Language": [
			false,
			false,
		],
		"Frequency Analyzer Manual": [
			false,
		],
		"Goodbye": [
			false,
			false,
			false,
			false,
		],
		"Goodnight, Dear World": [
			false,
			false,
		],
		"Grounding of Life": [
			false,
			false,
			false,
			false,
		],
		"Hindsight": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"History of the World": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"In Case of Emergency": [
			false,
			false,
			false,
		],
		"Inexistant Inscription": [
			false,
		],
		"Instructions for a New Body": [
			false,
		],
		"Interlinked": [
			false,
			false,
			false,
		],
		"Lab Report No. 3": [
			false,
			false,
			false,
		],
		"Lab Report No. 7": [
			false,
			false,
			false,
			false,
			false,
		],
		"Letter to Cirra": [
			false,
			false,
		],
		"Letter to Socar": [
			false,
		],
		"Letter to the Corba Temple": [
			false,
		],
		"Liquid Flux": [
			false,
			false,
		],
		"Lockout": [
			false,
			false,
		],
		"Mantra for Learning": [
			false,
			false,
			false,
		],
		"Marie's Note": [
			false,
		],
		"Memorial Request": [
			false,
			false,
		],
		"Message": [
			false,
		],
		"Minos": [
			false,
			false,
			false,
			false,
			false,
		],
		"Mirrored Universe": [
			false,
			false,
			false,
		],
		"My House": [
			false,
			false,
			false,
		],
		"Neodivine Birth": [
			false,
			false,
			false,
		],
		"Note to Dabbid": [
			false,
		],
		"Note to Self": [
			false,
		],
		"Obscurity": [
			false,
			false,
			false,
			false,
		],
		"On Dying Movements": [
			false,
			false,
			false,
			false,
			false,
		],
		"On Liberation": [
			false,
			false,
			false,
			false,
			false,
		],
		"On Reality": [
			false,
			false,
			false,
		],
		"On the Limits of Reality": [
			false,
			false,
			false,
		],
		"Order of the Unmade": [
			false,
		],
		"Parallel Conclusion": [
			false,
			false,
		],
		"Parallels": [
			false,
			false,
			false,
		],
		"Pathway": [
			false,
		],
		"Peering Into Depths": [
			false,
			false,
			false,
		],
		"Phronesis": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Plea for Peace": [
			false,
			false,
			false,
			false,
		],
		"Policy Announcement": [
			false,
			false,
		],
		"Postal Letters": [
			false,
			false,
			false,
			false,
		],
		"Presence": [
			false,
			false,
			false,
		],
		"Previous Owner's Notes": [
			false,
			false,
		],
		"Prison": [
			false,
		],
		"Project Clay Final Report": [
			false,
			false,
			false,
			false,
		],
		"Redirection": [
			false,
		],
		"Reflection of Self": [
			false,
			false,
			false,
			false,
		],
		"Reprimand": [
			false,
		],
		"Resignation": [
			false,
		],
		"Ritual for a Proper God": [
			false,
		],
		"Second Spark": [
			false,
			false,
		],
		"Secrets in Cycles": [
			false,
		],
		"Secrets of Speech": [
			false,
			false,
			false,
			false,
		],
		"Secrets": [
			false,
			false,
			false,
			false,
		],
		"Sequence": [
			false,
			false,
			false,
		],
		"Skyfall": [
			false,
			false,
			false,
			false,
		],
		"So-Called Ramblings of a Madman": [
			false,
			false,
			false,
		],
		"Solarflux": [
			false,
			false,
		],
		"Solaris": [
			false,
			false,
			false,
			false,
		],
		"Soldier's Letter": [
			false,
		],
		"Solitude": [
			false,
			false,
			false,
		],
		"Spirals": [
			false,
		],
		"Star Guides": [
			false,
			false,
		],
		"Starfall": [
			false,
			false,
			false,
			false,
		],
		"Station 1-9 Communications": [
			false,
		],
		"Station 1-Superserver Communications": [
			false,
		],
		"Station 17-21 Communications": [
			false,
			false,
			false,
			false,
		],
		"Station 9-17 Communications": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Station 9-21 Communications": [
			false,
			false,
			false,
		],
		"Station 9-X Communications": [
			false,
			false,
		],
		"Station Keys": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Stockpile": [
			false,
		],
		"Sun Sermons": [
			false,
			false,
			false,
		],
		"Temple Doors": [
			false,
			false,
			false,
		],
		"The Arrival": [
			false,
			false,
		],
		"The Ciliad": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"The Deities": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"The Deity": [
			false,
		],
		"The Fifth Aeon": [
			false,
			false,
			false,
			false,
		],
		"The Final Judgment": [
			false,
		],
		"The Fourth Aeon": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"The Great Joke": [
			false,
			false,
			false,
		],
		"The Holy Mountain": [
			false,
			false,
			false,
			false,
		],
		"The Hunter, Truan": [
			false,
			false,
			false,
			false,
		],
		"The Jacket": [
			false,
		],
		"The Last Trial": [
			false,
			false,
			false,
			false,
		],
		"The Last Weapon": [
			false,
			false,
			false,
		],
		"The Mirrored Sea": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"The Natural Unit": [
			false,
			false,
			false,
			false,
		],
		"The Path of Emperors": [
			false,
			false,
		],
		"The Pattern": [
			false,
			false,
			false,
		],
		"The Superserver": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"The Thing That Should Not Be": [
			false,
			false,
			false,
		],
		"The Third Aeon": [
			false,
			false,
			false,
			false,
			false,
		],
		"The Unmade": [
			false,
			false,
			false,
		],
		"The Veil": [
			false,
			false,
		],
		"The Way Out": [
			false,
			false,
			false,
		],
		"Things Without Name": [
			false,
			false,
			false,
		],
		"Think Twice": [
			false,
		],
		"Thirst": [
			false,
		],
		"Thought-Machines": [
			false,
			false,
			false,
			false,
			false,
		],
		"Time and Space": [
			false,
			false,
			false,
			false,
		],
		"Time Dedication": [
			false,
			false,
			false,
		],
		"Tome Esoterica": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Tower Messages": [
			false,
			false,
			false,
		],
		"Training Scenario": [
			false,
			false,
			false,
			false,
		],
		"Transcript of Bael-Cirra Meeting": [
			false,
			false,
			false,
		],
		"Transcript of Dabbid-Costeau Meeting": [
			false,
			false,
			false,
			false,
			false,
		],
		"Transmission": [
			false,
			false,
			false,
		],
		"Trues Purpose": [
			false,
			false,
			false,
			false,
		],
		"Tyrannus": [
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Unseen Concepts": [
			false,
			false,
			false,
			false,
		],
		"Warning": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Wims of a Believer": [
			false,
			false,
		],
		"Witness": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Work Orders": [
			false,
			false,
		],
		"World Primer": [
			false,
		],
		"Xeresium": [
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
		],
		"Xeretic Engravings": [
			false,
			false,
			false,
		],
	}

var authors = {
		"A Bargain for Gnosis": "Unknown",
		"A Case for Geometics": "Socar",
		"A Commentary On Ayodhia": "Leo",
		"A Declaration of War": "Sferdan",
		"A Hunt of Futility": "Unknown",
		"A Miracle": "Unknown",
		"A Thought": "Unknown",
		"A True Plan": "A",
		"Absurdity": "Unknown",
		"Aeons": "ISNBH",
		"An Introduction to Logic": "Hayes Cirra",
		"An Uncomfortable Reality": "Stein",
		"Ancient Engravings": "Unknown",
		"Archival Notes": "Archive Curators",
		"Art of Secrecy": "F",
		"Authorization": "Costeau",
		"Balance": "Hayes Cirra",
		"Beyond Deities": "A",
		"Blessing of War": "Unknown",
		"Boat User's Manual": "Costeau",
		"Bounds of Computation": "Nolud",
		"Brand New God": "F",
		"Celestial Clocks": "Stein",
		"Celestial Signs": "Leo",
		"Centroid Scans": "System",
		"Construction Notice": "Rob",
		"Contemplation": "Nolud",
		"Crypt": "Ficher",
		"Deepspace Objects": "Stein",
		"Deityrift": "Merlyn",
		"Desolation": "ISNBH",
		"DFL Notice": "DFL Research Team",
		"Digital Oceans": "Truan",
		"Disharmony": "Hayes Cirra",
		"Distributed Mind": "Costeau",
		"Divine Singularity": "Merlyn",
		"Emergency Power": "Unknown",
		"Entry Note": "Postal Manager",
		"Eyes Open To The Mad God": "Nolud",
		"Feodor": "Nolud",
		"Field Report No. 2": "Mandal",
		"Fields of Green": "Unknown",
		"Fingerprints of a Rift": "Merlyn",
		"Finite State Machines": "Unknown",
		"Flight Log": "Auto-Generated",
		"Flow, or Flux": "Sferdan",
		"Flux Empyrean": "Costeau",
		"Free Language": "Unknown",
		"Frequency Analyzer Manual": "Unknown",
		"Goodbye": "Corin Bael",
		"Goodnight, Dear World": "Nolud",
		"Grounding of Life": "Unknown",
		"Hindsight": "Unknown",
		"History of the World": "Hex",
		"In Case of Emergency": "Costeau",
		"Inexistant Inscription": "Unknown",
		"Instructions for a New Body": "System",
		"Interlinked": "Stein",
		"Lab Report No. 3": "Mandal",
		"Lab Report No. 7": "Mandal",
		"Letter to Cirra": "Unknown",
		"Letter to Socar": "Ficher",
		"Letter to the Corba Temple": "Hayes Cirra",
		"Liquid Flux": "Archive Curators",
		"Lockout": "Auto-Generated",
		"Mantra for Learning": "Unknown",
		"Marie's Note": "Marie",
		"Memorial Request": "Curators",
		"Message": "Unknown",
		"Minos": "Truan",
		"Mirrored Universe": "Salus",
		"My House": "Truan",
		"Neodivine Birth": "Archive Curators",
		"Note to Dabbid": "Costeau",
		"Note to Self": "Unknown",
		"Obscurity": "Unknown",
		"On Dying Movements": "Unknown",
		"On Liberation": "Bei Hale",
		"On Reality": "Xihun",
		"On the Limits of Reality": "Xihun",
		"Order of the Unmade": "Unknown",
		"Parallel Conclusion": "Corin Bael",
		"Parallels": "Corin Bael",
		"Pathway": "Avver",
		"Peering Into Depths": "Merlyn",
		"Phronesis": "Archive Curators",
		"Plea for Peace": "Unknown",
		"Policy Announcement": "Costeau",
		"Postal Letters": "Unknown",
		"Presence": "Truan",
		"Previous Owner's Notes": "Unknown",
		"Prison": "Leo",
		"Project Clay Final Report": "Stein",
		"Redirection": "Nolud",
		"Reflection of Self": "Unknown",
		"Reprimand": "Dabbid",
		"Resignation": "Truan",
		"Ritual for a Proper God": "Unknown",
		"Second Spark": "Archive Curators",
		"Secrets in Cycles": "J",
		"Secrets of Speech": "Unknown",
		"Secrets": "Unknown",
		"Sequence": "Unknown",
		"Skyfall": "Unknown",
		"So-Called Ramblings of a Madman": "A Madman",
		"Solarflux": "J",
		"Solaris": "F",
		"Soldier's Letter": "Unknown",
		"Solitude": "Ur",
		"Spirals": "Ficher",
		"Star Guides": "Merlyn",
		"Starfall": "Archive Curators",
		"Station 1-9 Communications": "Auto-Generated",
		"Station 1-Superserver Communications": "Auto-Generated",
		"Station 17-21 Communications": "Auto-Generated",
		"Station 9-17 Communications": "Auto-Generated",
		"Station 9-21 Communications": "Auto-Generated",
		"Station 9-X Communications": "Auto-Generated",
		"Station Keys": "Auto-Generated",
		"Stockpile": "Unknown",
		"Sun Sermons": "Auto-Generated",
		"Temple Doors": "Leo",
		"The Arrival": "Unknown",
		"The Ciliad": "Tho Ken",
		"The Deities": "Leo",
		"The Deity": "Valleison",
		"The Fifth Aeon": "Auder",
		"The Final Judgment": "Unknown",
		"The Fourth Aeon": "Auder",
		"The Great Joke": "Leo",
		"The Holy Mountain": "Olisk",
		"The Hunter, Truan": "Leo",
		"The Jacket": "Valleison",
		"The Last Trial": "Sferdan",
		"The Last Weapon": "Costeau",
		"The Mirrored Sea": "Nolud",
		"The Natural Unit": "Socar",
		"The Path of Emperors": "Cranden",
		"The Pattern": "Hayes Cirra",
		"The Superserver": "Costeau",
		"The Thing That Should Not Be": "Stein",
		"The Third Aeon": "Auder",
		"The Unmade": "J",
		"The Veil": "Ficher",
		"The Way Out": "Bei Hale",
		"Things Without Name": "Stein",
		"Think Twice": "Costeau",
		"Thirst": "Valleison",
		"Thought-Machines": "Dabbid",
		"Time and Space": "I",
		"Time Dedication": "Hail",
		"Tome Esoterica": "Leo",
		"Tower Messages": "Tower Collaborators",
		"Training Scenario": "System",
		"Transcript of Bael-Cirra Meeting": "Auto-Generated",
		"Transcript of Dabbid-Costeau Meeting": "Auto-Generated",
		"Transmission": "Auto-Generated",
		"Trues Purpose": "Sferdan",
		"Tyrannus": "Leo",
		"Unseen Concepts": "Glavov",
		"Warning": "Sferdan",
		"Wims of a Believer": "Vonnie",
		"Witness": "ISNBH",
		"Work Orders": "Costeau",
		"World Primer": "Valleison",
		"Xeresium": "Unknown",
		"Xeretic Engravings": "Unknown",
	}

var favorites = []


# --- Scènes traduites, fabriquées par le jeu lui-même -----------------------
#
# Généré par tools/gen_scenes_gd.py — ne pas éditer à la main.

const FR_SCENES := {
	"res://FluxGame/MainMenu/main_menu.tscn": {
		"18": "-Jouer-",
	},
	"res://Locations/Abstract Form/abstract_form.tscn": {
		"37": "Le sol abrite un petit\nclavier encastré.",
	},
	"res://Locations/Acropolis/acropolis.tscn": {
		"34": "Quelle divinité n'a qu'un seul fidèle ?",
	},
	"res://Locations/Acropolis/follower.tscn": {
		"11": "Qui est mon fidèle \nle plus dévoué ?\n",
	},
	"res://Locations/Alterspace/alterspace.tscn": {
		"16": "\"Le premier d'entre eux amènerait le monde à son centre.\nIl apporterait la stabilité.\"",
	},
	"res://Locations/Beacons/pattern_box.tscn": {
		"35": "Séquence acceptée.",
	},
	"res://Locations/Constellation/constellation.tscn": {
		"77": "Mot de passe de\ndémarrage système :",
	},
	"res://Locations/Courtyard House/courtyard_house.tscn": {
		"23": "\"Le deuxième d'entre eux se tiendrait là, en silence.\nÉlégant et gracieux dans sa beauté,\nil se ferait rare, et pourtant inoubliable.\"",
	},
	"res://Locations/Deep Flux Lab/deep_flux_lab.tscn": {
		"120": "Tout comme elles consacrent\nl'écriture et le savoir,\nque les étoiles au-dessus\nte disent ce que tu\ndois savoir.",
		"152": "\"Et alors l'un des anciens\ns'avancera,\net réclamera la place qui lui est\ninscrite dans les étoiles.\"",
	},
	"res://Locations/Flux Anomaly/flux_anomaly.tscn": {
		"34": "La surface fond\nà ton contact.",
	},
	"res://Locations/Flux Anomaly/flux_anomaly_2.tscn": {
		"36": "La surface fond\nà ton contact.",
	},
	"res://Locations/Flux Anomaly/flux_anomaly_3.tscn": {
		"37": "La surface fond\nà ton contact.",
	},
	"res://Locations/Flux Anomaly/well_of_uplifting.tscn": {
		"57": "Es-tu\nsûr que\nc'est ce que \ntu veux ?",
	},
	"res://Locations/Golden Idol/golden_idol.tscn": {
		"32": "Il y a longtemps, quelqu'un a tracé\nun mot sur ce croissant.",
		"46": "\"Le suivant serait rusé,\ncalculant la meilleure voie vers\nson profit à la fin des temps.\"",
	},
	"res://Locations/Greater Corba/greater_corba.tscn": {
		"51": "\"Le deuxième à paraître porterait le\npoids du monde dans sa main. \nIl serait doué en logique,\ncompétence nécessaire à l'ouvrage qui lui revient. \"",
	},
	"res://Locations/Hall of Forms/hall_of_forms.tscn": {
		"47": "Qu'est-ce que c'est ?",
	},
	"res://Locations/Hall of Judgment/crimes_list.tscn": {
		"11": "NOMMEZ LES TÉMOINS",
		"12": "Effacement de l'Histoire :",
		"14": "Désolation des Divinités :",
		"15": "Mépris de la Vie :",
		"16": "Destruction des Cités :",
		"17": "Génocide de la Pensée :",
		"18": "Asservissement de la Matière :",
		"19": "Éclatement de la Réalité :",
		"20": "[Valider]",
	},
	"res://Locations/Hand of Wim/hand_of_wim.tscn": {
		"38": "Que le jugement de",
		"40": "soit rendu.",
	},
	"res://Locations/Hypercube/hypercube.tscn": {
		"35": "La séquence est :",
	},
	"res://Locations/Isle of Change/isle_of_change.tscn": {
		"37": "\"Ils auront un appétit de ruine,\ndes desseins qui dépassent l'entendement\net une puissance au-delà de toute mesure.\"",
	},
	"res://Locations/Labyrinth/labyrinth.tscn": {
		"116": "Le premier à paraître serait jusque-là inconnu. \nIl viendra au grondement de trompettes sourdes,\net annoncera la fin.",
	},
	"res://Locations/Launch Site/launch_site.tscn": {
		"37": "\"Un autre viendra peu après, porteur de\nnouveaux instruments de guerre.\"",
		"60": "Clé maîtresse :",
	},
	"res://Locations/Memorial to the Lost/memorial_to_the_lost.tscn": {
		"38": "À la mémoire de",
	},
	"res://Locations/Parallel Exhibition/parallel_exhibition.tscn": {
		"97": "Y a-t-il équilibre ?",
	},
	"res://Locations/Power Plant/power_terminal.tscn": {
		"4": "Alimentation",
		"25": "État 1",
		"26": "État 2",
		"27": "État 3",
		"28": "État 4",
		"29": "État 5",
		"30": "État 6",
		"31": "État 7",
		"32": "État 8",
		"33": "État 9",
		"34": "État 10",
		"35": "État 11",
		"36": "État 12",
		"37": "État 13",
		"38": "État 14",
		"39": "État 15",
		"40": "État 16",
		"42": "Séquence acceptée.",
	},
	"res://Locations/Shrine of Siciphos/shrine_of_siciphos.tscn": {
		"24": "\"L'un viendra avec un savoir\nqui ne peut être donné.\"",
	},
	"res://Locations/Star Study/star_study.tscn": {
		"19": "\"Celui qui a toujours existé, qui existe,\net qui existera se manifestera.\"",
	},
	"res://Locations/Station X/station_x.tscn": {
		"47": "IDENTITÉ SCANNÉE\nRéponds à ta question\nde récupération\npersonnelle :\n\"Quand ta foi a-t-elle\ncommencé à vaciller ?\"",
		"65": "\"La forme du suivant serait incompréhensible,\nà l'image du message qu'il porte.\nEt bien que la nouvelle qu'il apporte soit funeste,\nelle ne pourrait se comprendre qu'après coup.\"",
	},
	"res://Locations/Sun Temple/sun_temple.tscn": {
		"117": "\"Nul ne les attendrait,\ncar jamais ils n'ont agi. \nBeaucoup douteront qu'ils aient même une origine.\"",
		"150": "L'Éclat attend ta parole.\n",
	},
	"res://Locations/Superserver/superserver.tscn": {
		"103": "Mot de passe de démarrage :",
		"106": "IDENTITÉ SCANNÉE\nRéponds à ta question\nde récupération personnelle :\n\"Quand ta foi a-t-elle\ncommencé à vaciller ?\"",
		"109": "Indice mot de passe :\nFréquence",
	},
	"res://Locations/Testing Grounds/testing_grounds.tscn": {
		"20": "\"Il existe d'innombrables possibilités pour un monde,\net celui-ci n'en est qu'une.\nIl était inévitable que nous devions\npasser à une autre possibilité.\"\n",
	},
	"res://Locations/The House/the_house.tscn": {
		"40": "\"Des idées nouvelles couleront,\net des choses étrangères à ce monde\ndeviendront possibles.\"",
	},
	"res://Locations/Tower of Languages/tower_of_languages.tscn": {
		"45": "Réponse :",
	},
	"res://Locations/Universal Mirror/universal_mirror.tscn": {
		"18": "\"Avant la fin, le désolé parlera.\nSon corps est le tout, et le monde tremblera de\nce que cela implique.\"",
	},
	"res://Scenes/Boat/boat_warning.tscn": {
		"10": "ALERTE\nCOLLISION\n",
	},
	"res://Scenes/Boat/radar.tscn": {
		"13": "Aucun scan récent.\n\n",
	},
	"res://Scenes/Fishing/fish_caught_screen.tscn": {
		"14": "Taille : Poids :",
		"15": "Pêché 1",
	},
	"res://Scenes/chime.tscn": {
		"14": "Gamme : [Majeure]  Mineure  Pentatonique \nHauteur : 0.0\nBrouillage : 0.1",
	},
	"res://Scenes/ending.tscn": {
		"16": "Le Quatrième Aeon commence",
		"18": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Quand le dernier d'entre nous reposera à jamais, \nalors seulement le monde prendra\nsa forme finale.\"",
		"19": "Le Dieu Dément",
		"20": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Qu'est-ce qui fait de ce monde ce qu'il est ?\"",
		"21": "La Seconde Calamité",
		"22": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Et tout fut changé, car telle était\nla nature du Flux. Un monde nouveau.\"",
		"23": "La Sombre Vérité",
		"24": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"La réalité a changé d'une façon que nous ne pourrions\njamais comprendre. Nous n'aurions jamais dû voir ça.\"",
		"26": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Il était vrai que les choses étaient brisées. Mais il\nn'était pas vrai qu'on ne pût les réparer. La vérité\nfondamentale n'est connue que de toi, et de toi seul.\"",
		"28": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Et je me tenais là, au bord du temps. Une réalité\nderrière moi et une autre devant. Je n'ai jamais été seul.\nIls attendaient depuis toujours que je les trouve dans la cité.\"",
		"29": "La Voie du Possible",
		"30": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Le Quatrième Aeon ? C'est un récit d'un autre temps...\nsi pareille chose devait advenir, ce serait\nbien, bien plus tard. Regarde le monde, que\nvois-tu ? La vie. Le monde déborde de vie.\nLà où nous existons, rien ne peut rester immobile.\"",
		"31": "Faille Sans Filtre",
		"32": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Nous avions oublié ce qu'étaient les divinités.\nMoins nous nous en souvenions, plus elles faiblissaient.\nNotre monde a lentement sombré dans la stagnation. La faille\ns'est refermée... mais elle vient de s'ouvrir à nouveau.\n\nUn monde nouveau coule jusqu'à nous.\"",
		"33": "La Grande Farce",
		"34": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Ça n'a jamais eu beaucoup de sens, n'est-ce pas ?\nJe crois que le contenu de la farce\nn'a jamais été la farce elle-même.\n\nPris pour des idiots, une réalité nouvelle approche.\"",
		"35": "La Prison",
		"36": "\n\n\n\n\n\n\n\n\n\n\n\n\n\"Mythes et légendes parlaient de choses que nous avions oubliées.\nElles étaient réelles, mais retenues par quelque chose, il y a longtemps.\nQuelque chose de neuf s'annonce. Elles sont libres. Elles étaient là\npour le début de ce monde, et elles seront là pour\nle commencement du suivant.\"",
	},
	"res://Scenes/fish_scanner.tscn": {
		"14": "Aucun scan récent.\nATTENTION - La pêche n'est pas implémentée\n\n",
	},
	"res://Scenes/frequency_analyzer.tscn": {
		"11": " REPOS\n=========\nFREQ:9999",
	},
	"res://Scenes/journal.tscn": {
		"11": "Textes",
		"12": "Lieux",
		"13": "Pêche",
		"14": "Rechercher…",
		"15": "Voir les favoris",
		"16": "Effacer\n",
		"18": "90/? trouvés",
		"22": "Tes notes ici...",
		"23": "Clé de déchiffrement...",
		"25": "Étoiles au-dessus",
		"28": "Progression",
		"30": "Orienter le bateau",
		"33": "Épingler le lieu",
		"34": "Favori",
	},
	"res://Scenes/main_menu.tscn": {
		"32": "[Commencer]",
		"34": "[Tutoriel]",
		"35": "[Mode debug]",
		"36": "[Réglages]",
		"37": "[Crédits]",
		"38": "[Quitter]\n",
		"39": "1.3.0- \"Aeons\"",
		"40": "[Bugs / Retours]",
		"44": "Réglages",
		"45": "Résolution de l'océan",
		"50": "Modifie la densité des points du maillage de l'océan.",
		"51": "Qualité des portails",
		"54": "Modifie le nombre de pixels utilisés pour les portails sans raccord.",
		"55": "Sensibilité souris",
		"58": "Règle le volume des différentes sources sonores.",
		"59": "FOV caméra",
		"63": "Règle le champ de vision de la caméra.",
		"64": "Échelle de l'interface",
		"66": "Modifie la taille de l'interface. ATTENTION : les valeurs extrêmes peuvent donner des résultats bizarres.",
		"67": "Lissage caméra",
		"68": "Adoucit les mouvements de caméra à la souris.",
		"69": "Masquer les entités",
		"70": "Masque les entités qui foncent sur toi.",
		"71": "Afficher les contours",
		"72": "Désactiver peut améliorer les performances.",
		"73": "Inverser la minicarte",
		"74": "Inverse la rotation de la minicarte.",
		"75": "Plein écran",
		"76": "Passe le jeu en plein écran !",
		"77": "Optimisation océan & monde",
		"78": "Active des optimisations qui améliorent nettement \nles performances, au prix du détail de l'océan.",
		"79": "Volume général",
		"80": "Volume du jeu",
		"81": "Volume musique",
		"82": "Volume interface",
		"83": "Redémarre le jeu pour appliquer ces réglages.",
		"84": "Nombre d'étoiles",
		"86": "Options de réinitialisation",
		"87": "Zone rouge ! Effet immédiat !",
		"88": "Réinitialise ta position dans le monde. - Tape \"Reset Position\"",
		"89": "Clé de réinitialisation...",
		"90": "Efface toutes les découvertes. - Tape \"Reset Discoveries\"",
		"91": "[Annuler]",
		"92": "[Appliquer]",
		"93": "[Enregistrer et fermer]",
		"94": "Crédits",
		"95": "Créé par : Cash Hilstad\nArt de l'entité \"Flux\" par Miguel Madrigal\nTesteurs : Cooper, Ringo Roadagain, imaducklol, squabbled, \nUnAstronomical, Robert Mackey, Carson Frost, Goldenbarky,\nAllSol, ekorz, Marko Everest, neolog, Hamish K, Sean Kulbeth,\nCory Jansen, Adrian \"Kage\" Connor, Adrien Nivaggioli, ikeaman,\nguillotine chan, Krillus, David Whitechapel, Marleyjedi, sakhmet\nMore Cowbell, Mr. Nemo, JayFa, thesilverapple30, SqueeSpree,\nPhummyLW, SantoSama, Pedro Gaio, Jacob P, ghostpopjake\n",
		"96": "[Retour]",
	},
	"res://Scenes/pause_screen.tscn": {
		"10": "En pause",
		"11": " Reprendre ",
		"13": "Sauvegarder",
		"14": "Retour au menu",
		"15": "Quitter le jeu",
		"16": "Le journal et la position du bateau seront sauvegardés !",
		"17": "Bugs / Retours ?",
		"20": "Mode dieu",
		"22": "Lissage caméra",
		"25": "Adoucit les mouvements de caméra à la souris.",
		"26": "Masquer la visière",
		"27": "Retire la visière du casque pour réduire les reflets.",
		"28": "Afficher les contours",
		"29": "Désactiver peut améliorer les performances.",
		"30": "Masquer l'interface",
		"31": "Masque l'interface pour les belles captures.",
		"32": "Masquer les entités",
		"33": "Masque les entités qui foncent sur toi.",
		"34": "Inverser la minicarte",
		"35": "Inverse la rotation de la minicarte.",
		"37": "Passe le jeu en plein écran !",
		"38": "Sensibilité souris",
		"41": "Règle le volume des différentes sources sonores,",
		"42": "FOV caméra",
		"46": "Règle le champ de vision de la caméra.",
		"47": "Échelle de l'interface",
		"50": "Modifie la taille de l'interface.",
		"51": "Vitesse du texte",
		"53": "Modifie la vitesse de défilement du texte.",
		"54": "Optimisation océan & monde",
		"55": "Active des optimisations qui améliorent nettement \nles performances, au prix du détail de l'océan.",
		"56": "Volume général",
		"58": "Volume du jeu",
		"59": "Volume musique",
		"60": "Volume interface",
		"62": "[Fermer]",
	},
	"res://Scenes/player.tscn": {
		"70": "Connexion…",
		"71": "Connexion établie.",
		"73": "<Clic gauche> pour continuer.",
		"74": "Ceci est la version démo.\nTu peux explorer toute la planète, mais\nles seuls lieux visitables sont ceux\nque tu vois depuis le point de départ.",
		"94": "Entrée ajoutée au journal",
		"95": "\n\n\n\n[--Fréquence détectée !--]",
		"115": "Souffle",
		"116": "Décalage RG : -3.4",
		"117": "Clarté : 1.0",
		"118": "Énergie locale : 1.0",
		"119": "Particules : 1.0",
	},
	"res://Scenes/world_map.tscn": {
		"94": "Jour permanent",
		"104": "Nuit permanente",
		"112": "Mi-loin mi-près",
	},
	"res://Tutorial/tutorial.tscn": {
		"75": "Saisis la fréquence cible...",
	},
}

# Renseigné par patcher.lua au chargement : lui seul connaît le chemin du mod.
const MOD_DIR := "@@MOD_DIR@@"


func _ready() -> void:
	_fabriquer_les_scenes()


# La cible réelle d'une scène. Godot remplace chaque `.tscn` par un renvoi vers
# `.godot/exported/<hash>/export-<md5>-<nom>.scn`. Écrire ailleurs ne fait rien,
# silencieusement — et ce chemin porte l'empreinte du contenu, donc il change à
# chaque mise à jour du jeu. C'est ce qui nous sert de marque de fraîcheur.
func _cible_remap(chemin: String) -> String:
	var renvoi := chemin + ".remap"
	if not FileAccess.file_exists(renvoi):
		return ""
	for ligne in FileAccess.get_file_as_string(renvoi).split("\n"):
		if ligne.begins_with("path="):
			return ligne.split("\"")[1]
	return ""


func _fabriquer_les_scenes() -> void:
	if MOD_DIR.begins_with("@@"):
		print("SCENES chemin du mod non renseigne, scenes laissees en anglais")
		return

	var cibles := {}
	var signature := ""
	for chemin in FR_SCENES:
		var cible := _cible_remap(chemin)
		if cible.is_empty():
			continue
		cibles[chemin] = cible
		signature += cible

	# La marque porte la signature des cibles. Le jeu change, elle change, et
	# les scènes se refont — sans quoi l'interface repasserait en anglais sans
	# le moindre message, ce qui est le mode d'echec habituel par ici.
	var marque := MOD_DIR + "/data/.genere"
	var attendue := signature.sha256_text()
	if FileAccess.file_exists(marque) and FileAccess.get_file_as_string(marque).strip_edges() == attendue:
		return

	var ecrites := 0
	var chaines := 0
	var hors_champ := 0
	var echecs := 0
	for chemin in cibles:
		var scene = ResourceLoader.load(chemin, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE)
		if scene == null:
			echecs += 1
			continue
		var bundled: Dictionary = scene.get("_bundled")
		if bundled == null or not bundled.has("variants"):
			echecs += 1
			continue
		var variants: Array = bundled["variants"]
		var touche := false
		for cle in FR_SCENES[chemin]:
			var i := int(cle)
			# Un indice hors champ, ou qui ne designe plus une chaine, veut dire
			# que la scene a change depuis la traduction. On passe : mieux vaut
			# une ligne en anglais qu'une scene corrompue.
			if i < 0 or i >= variants.size() or not variants[i] is String:
				hors_champ += 1
				continue
			variants[i] = FR_SCENES[chemin][cle]
			chaines += 1
			touche = true
		if not touche:
			continue
		bundled["variants"] = variants
		scene.set("_bundled", bundled)

		var destination: String = MOD_DIR + "/data/" + (cibles[chemin] as String).trim_prefix("res://")
		DirAccess.make_dir_recursive_absolute(destination.get_base_dir())
		if ResourceSaver.save(scene, destination) == OK:
			ecrites += 1
		else:
			echecs += 1

	var f := FileAccess.open(marque, FileAccess.WRITE)
	if f:
		f.store_string(attendue)
		f.close()

	print("SCENES %d scenes ecrites, %d chaines, %d hors champ, %d echecs"
		% [ecrites, chaines, hors_champ, echecs])
	print("SCENES fabriquees pour cette version du jeu — relance pour les voir.")
