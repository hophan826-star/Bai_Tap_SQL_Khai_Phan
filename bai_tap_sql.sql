create database baitap_sql;
create table if not exists "users"(
    "id" SERIAL primary key,
    "fullName" VARCHAR(255),
    "email" VARCHAR(255),
    "password" VARCHAR(255),

    "createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "restaurants" (
	"id" SERIAL primary key,
	"resName" VARCHAR(255),
	"image" VARCHAR(255),
	"description" TEXT,
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "food_types" (
	"id" SERIAL primary key,
	"typeName" VARCHAR(255),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "foods" (
	"id" SERIAL primary key,
	"foodName" VARCHAR(255),
	"image" VARCHAR(255),
	"price" FLOAT,
	"description" TEXT,
	"typeId" int,
	
	FOREIGN KEY ("typeId") REFERENCES "food_types"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "sub_foods" (
	"id" SERIAL primary key,
	"subName" VARCHAR(255),
	"subPrice" FLOAT,
	"foodId" int,
	
	FOREIGN KEY ("foodId") REFERENCES "foods"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "orders" (
	"id" SERIAL primary key,
	"userId" int,
	"foodId" int,
	"amount" int,
	"code" VARCHAR(255),
	"arrSubId" VARCHAR(255),
	
	FOREIGN KEY ("userId") REFERENCES "users"("id"),
	FOREIGN KEY ("foodId") REFERENCES "foods"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "rate_res" (
	"id" SERIAL primary key,
	"userId" int,
	"resId" int,
	"amount" int,
	"dateRate" timestamp default CURRENT_TIMESTAMP,
	
	FOREIGN KEY ("userId") REFERENCES "users"("id"),
	FOREIGN KEY ("resId") REFERENCES "restaurants"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);

create table if not exists "like_res" (
	"id" SERIAL primary key,
	"userId" int,
	"resId" int,
	"dateLike" timestamp default CURRENT_TIMESTAMP,
	
	FOREIGN KEY ("userId") REFERENCES "users"("id"),
	FOREIGN KEY ("resId") REFERENCES "restaurants"("id"),
	
	"createdAt" timestamp not null default CURRENT_TIMESTAMP,
	"updatedAt" timestamp not null default CURRENT_TIMESTAMP
);






INSERT into "users" ("fullName", "email", "password") VALUES
					('Phan Minh', 'minh@gmail.com', '123'),
					('Minh Tuan', 'tuan@gmail.com', '123'),
					('Hoang Yen', 'yen@gmail.com', '123'),
					('Gia Bao', 'bao@gmail.com', '123'),
					('Thanh Truc', 'truc@gmail.com', '123'),
					('Duc Anh', 'anh@gmail.com', '123'),
					('Quoc Huy', 'huy@gmail.com', '123');

INSERT into "restaurants" ("resName", "image", "description") VALUES
					('Mi Tron Indomie', 'hinh1.jpg', 'mi tron'),
					('Ga Ran Yummy', 'hinh2.jpg', 'ga ran'),
					('Cafe Diem Hen', 'hinh3.jpg', 'nuoc uong'),
					('Com Ga 3 Nghia', 'hinh4.jpg', 'com ga');

INSERT into "food_types" ("typeName") VALUES
					('Do an'),
					('Thuc uong');

INSERT into "foods" ("foodName", "price", "description", "typeId") VALUES
					('Mi tron trung', 45000, 'ngon', 1),
					('Dui ga ran', 35000, 'gion', 1),
					('Khoai tay lac', 25000, 'beo', 1),
					('Bac xiu', 29000, 'ngot', 2);

INSERT into "sub_foods" ("subName", "subPrice", "foodId") VALUES
					('Trung op la', 8000, 1),
					('Xuc xich', 10000, 1);

INSERT INTO "like_res" ("userId", "resId") VALUES
						(1, 1),
						(1, 2),
						(1, 3),
						(2, 1),
						(2, 2),
						(3, 1),
						(3, 4),
						(4, 2),
						(5, 1);

INSERT INTO "rate_res" ("userId", "resId", "amount") VALUES
						(1, 1, 5),
						(2, 2, 4),
						(3, 1, 5);


INSERT INTO "orders" ("userId", "foodId", "amount") VALUES
						(2, 1, 1),
						(2, 2, 2),
						(2, 3, 1),
						(2, 4, 1),
						(1, 1, 2),
						(1, 2, 1),
						(3, 2, 1),
						(4, 4, 1);



SELECT "userId", "users"."id", "email", "fullName", COUNT("userId") AS "So lan like"
FROM "like_res"
INNER JOIN "users" ON "like_res"."userId" = "users"."id"
GROUP BY "userId", "users"."id"
ORDER BY "So lan like" DESC
LIMIT 5;


SELECT "resId", "restaurants"."id", "resName", "description", COUNT("resId") AS "So luot like"
FROM "like_res"
INNER JOIN "restaurants" ON "like_res"."resId" = "restaurants"."id"
GROUP BY "resId", "restaurants"."id"
ORDER BY "So luot like" DESC
LIMIT 2;


SELECT "orders"."userId", "email", "fullName", COUNT("orders"."userId") AS "So lan mua"
FROM "orders"
INNER JOIN "users" on "users"."id" = "orders"."userId"
GROUP BY "users"."id", "orders"."userId"
HAVING COUNT("orders"."userId") = (
	SELECT MAX(temp."count")
	FROM (
		SELECT COUNT("orders"."userId")
		FROM "orders"
		GROUP BY "orders"."userId"
	) AS temp
);


SELECT "users"."id", "users"."fullName", "users"."email"
FROM "users"
LEFT JOIN "orders" ON "orders"."userId" = "users"."id"
LEFT JOIN "like_res" ON "like_res"."userId" = "users"."id"
LEFT JOIN "rate_res" ON "rate_res"."userId" = "users"."id"
WHERE "orders"."id" IS NULL 
AND "like_res"."id" IS NULL 
AND "rate_res"."id" IS NULL;