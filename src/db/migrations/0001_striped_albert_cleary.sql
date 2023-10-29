DROP INDEX IF EXISTS `nameIdx`;--> statement-breakpoint
CREATE UNIQUE INDEX `nameIdx` ON `surveys` (`name`,`owner`);