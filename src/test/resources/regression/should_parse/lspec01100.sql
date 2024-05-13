USE AdventureWorks2008R2;
GO

CREATE TABLE DocumentStore
(DocID int PRIMARY KEY,
	Title varchar(200) NOT NULL,
	ProductionSpecification varchar(20) SPARSE NULL,
	ProductionLocation smallint SPARSE NULL,
	MarketingSurveyGroup varchar(20) SPARSE NULL ) ;
GO

INSERT DocumentStore(DocID, Title, ProductionSpecification, ProductionLocation)
VALUES (1, 'Tire Spec 1', 'AXZZ217', 27);
GO

INSERT DocumentStore(DocID, Title, MarketingSurveyGroup)
VALUES (2, 'Survey 2142', 'Men 25 - 35');
GO

