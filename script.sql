-- Перед выполнением уберите галочку "Enable foreign key checks"
-- Before you perform uncheck "Enable foreign key checks"

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `create_event_tag`;

INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Афиша');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Кино');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Музыка');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Музеи, выставки, библиотеки');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Фестивали, массовые гуляния, конкурсы');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Спорт');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Образование');
INSERT INTO `create_event_tag` (`id`, `title`) VALUES (NULL, 'Услуги');

TRUNCATE TABLE `create_event_agerating`;

INSERT INTO `create_event_agerating` (`id`, `age_rating`) VALUES (NULL, '0');
INSERT INTO `create_event_agerating` (`id`, `age_rating`) VALUES (NULL, '6');
INSERT INTO `create_event_agerating` (`id`, `age_rating`) VALUES (NULL, '12');
INSERT INTO `create_event_agerating` (`id`, `age_rating`) VALUES (NULL, '16');
INSERT INTO `create_event_agerating` (`id`, `age_rating`) VALUES (NULL, '18');

SET FOREIGN_KEY_CHECKS = 1;