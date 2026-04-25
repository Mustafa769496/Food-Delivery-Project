USE [master]
GO
/****** Object:  Database [Food Delivery]    Script Date: 4/25/2026 6:25:36 PM ******/
CREATE DATABASE [Food Delivery]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Food Delivery', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\Food Delivery.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Food Delivery_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\Food Delivery_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Food Delivery] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Food Delivery].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Food Delivery] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Food Delivery] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Food Delivery] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Food Delivery] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Food Delivery] SET ARITHABORT OFF 
GO
ALTER DATABASE [Food Delivery] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Food Delivery] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Food Delivery] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Food Delivery] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Food Delivery] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Food Delivery] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Food Delivery] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Food Delivery] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Food Delivery] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Food Delivery] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Food Delivery] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Food Delivery] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Food Delivery] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Food Delivery] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Food Delivery] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Food Delivery] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Food Delivery] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Food Delivery] SET RECOVERY FULL 
GO
ALTER DATABASE [Food Delivery] SET  MULTI_USER 
GO
ALTER DATABASE [Food Delivery] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Food Delivery] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Food Delivery] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Food Delivery] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Food Delivery] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Food Delivery] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [Food Delivery] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Food Delivery] SET QUERY_STORE = ON
GO
ALTER DATABASE [Food Delivery] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Food Delivery]
GO
/****** Object:  Schema [delivery_schema]    Script Date: 4/25/2026 6:25:36 PM ******/
CREATE SCHEMA [delivery_schema]
GO
/****** Object:  Schema [order_schema]    Script Date: 4/25/2026 6:25:36 PM ******/
CREATE SCHEMA [order_schema]
GO
/****** Object:  Schema [restaurant_schema]    Script Date: 4/25/2026 6:25:36 PM ******/
CREATE SCHEMA [restaurant_schema]
GO
/****** Object:  Schema [user_schema]    Script Date: 4/25/2026 6:25:36 PM ******/
CREATE SCHEMA [user_schema]
GO
/****** Object:  Table [delivery_schema].[deliveries]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [delivery_schema].[deliveries](
	[delivery_id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[driver_id] [int] NULL,
	[delivery_time] [datetime2](7) NULL,
	[status] [varchar](20) NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[delivery_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [delivery_schema].[delivery_drivers]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [delivery_schema].[delivery_drivers](
	[driver_id] [int] IDENTITY(1,1) NOT NULL,
	[driver_name] [varchar](50) NOT NULL,
	[phone] [varchar](20) NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[driver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order_schema].[order_items]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order_schema].[order_items](
	[order_item_id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[menuitem_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[order_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [order_schema].[orders]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [order_schema].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[restaurant_id] [int] NOT NULL,
	[order_date] [datetime2](7) NULL,
	[status] [varchar](20) NOT NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [restaurant_schema].[menuitems]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [restaurant_schema].[menuitems](
	[menuitem_id] [int] IDENTITY(1,1) NOT NULL,
	[restaurant_id] [int] NOT NULL,
	[item_name] [varchar](100) NOT NULL,
	[description] [varchar](255) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[rating] [decimal](3, 2) NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[menuitem_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [restaurant_schema].[restaurants]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [restaurant_schema].[restaurants](
	[restaurant_id] [int] IDENTITY(1,1) NOT NULL,
	[restaurant_name] [varchar](100) NOT NULL,
	[address] [varchar](255) NULL,
	[phone] [varchar](20) NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[restaurant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [user_schema].[users]    Script Date: 4/25/2026 6:25:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [user_schema].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[email] [varchar](100) NOT NULL,
	[phone] [varchar](20) NOT NULL,
	[address] [varchar](255) NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [delivery_schema].[deliveries] ON 

INSERT [delivery_schema].[deliveries] ([delivery_id], [order_id], [driver_id], [delivery_time], [status], [created_at]) VALUES (5, 1005, 3, NULL, N'Assigned', CAST(N'2026-04-22T18:17:16.8766667' AS DateTime2))
INSERT [delivery_schema].[deliveries] ([delivery_id], [order_id], [driver_id], [delivery_time], [status], [created_at]) VALUES (6, 1006, 4, NULL, N'OnTheWay', CAST(N'2026-04-22T18:17:16.8766667' AS DateTime2))
INSERT [delivery_schema].[deliveries] ([delivery_id], [order_id], [driver_id], [delivery_time], [status], [created_at]) VALUES (7, 1007, 3, NULL, N'Delivered', CAST(N'2026-04-22T18:17:16.8766667' AS DateTime2))
SET IDENTITY_INSERT [delivery_schema].[deliveries] OFF
GO
SET IDENTITY_INSERT [delivery_schema].[delivery_drivers] ON 

INSERT [delivery_schema].[delivery_drivers] ([driver_id], [driver_name], [phone], [created_at]) VALUES (3, N'Ali Driver', N'01555555555', CAST(N'2026-04-22T18:07:59.3866667' AS DateTime2))
INSERT [delivery_schema].[delivery_drivers] ([driver_id], [driver_name], [phone], [created_at]) VALUES (4, N'Mahmoud Driver', N'01666666666', CAST(N'2026-04-22T18:07:59.3866667' AS DateTime2))
SET IDENTITY_INSERT [delivery_schema].[delivery_drivers] OFF
GO
SET IDENTITY_INSERT [order_schema].[order_items] ON 

INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1002, 1006, 6, 2, CAST(160.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1003, 1007, 3, 1, CAST(70.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1004, 1005, 4, 3, CAST(90.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1005, 1007, 5, 10, CAST(700.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1006, 2009, 6, 4, CAST(120.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1007, 2009, 4, 4, CAST(380.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1008, 2010, 4, 6, CAST(570.00 AS Decimal(10, 2)))
INSERT [order_schema].[order_items] ([order_item_id], [order_id], [menuitem_id], [quantity], [price]) VALUES (1009, 1007, 6, 3, CAST(90.00 AS Decimal(10, 2)))
SET IDENTITY_INSERT [order_schema].[order_items] OFF
GO
SET IDENTITY_INSERT [order_schema].[orders] ON 

INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (1005, 1011, 2, CAST(N'2026-04-22T18:03:09.3600000' AS DateTime2), N'Pending', CAST(N'2026-04-22T18:03:09.3600000' AS DateTime2))
INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (1006, 1011, 2, CAST(N'2026-04-22T18:03:09.3600000' AS DateTime2), N'Confirmed', CAST(N'2026-04-22T18:03:09.3600000' AS DateTime2))
INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (1007, 1010, 3, CAST(N'2026-04-22T18:03:09.3600000' AS DateTime2), N'Delivered', CAST(N'2026-04-22T18:03:09.3600000' AS DateTime2))
INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (1009, NULL, 4, CAST(N'2026-04-23T18:07:44.0300000' AS DateTime2), N'Cancelled', CAST(N'2026-04-23T18:07:44.0300000' AS DateTime2))
INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (2009, 1016, 4, CAST(N'2026-04-25T17:15:01.2966667' AS DateTime2), N'Confirmed', CAST(N'2026-04-25T17:15:01.2966667' AS DateTime2))
INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (2010, 1015, 4, CAST(N'2026-04-25T17:15:01.2966667' AS DateTime2), N'Cancelled', CAST(N'2026-04-25T17:15:01.2966667' AS DateTime2))
INSERT [order_schema].[orders] ([order_id], [user_id], [restaurant_id], [order_date], [status], [created_at]) VALUES (2011, 1013, 2, CAST(N'2026-04-25T17:15:01.2966667' AS DateTime2), N'Preparing', CAST(N'2026-04-25T17:15:01.2966667' AS DateTime2))
SET IDENTITY_INSERT [order_schema].[orders] OFF
GO
SET IDENTITY_INSERT [restaurant_schema].[menuitems] ON 

INSERT [restaurant_schema].[menuitems] ([menuitem_id], [restaurant_id], [item_name], [description], [price], [rating], [created_at]) VALUES (3, 2, N'Margherita Pizza', N'Classic pizza', CAST(80.00 AS Decimal(10, 2)), CAST(4.50 AS Decimal(3, 2)), CAST(N'2026-04-22T17:55:56.2266667' AS DateTime2))
INSERT [restaurant_schema].[menuitems] ([menuitem_id], [restaurant_id], [item_name], [description], [price], [rating], [created_at]) VALUES (4, 2, N'Pepperoni Pizza', N'Spicy pizza', CAST(95.00 AS Decimal(10, 2)), CAST(4.70 AS Decimal(3, 2)), CAST(N'2026-04-22T17:55:56.2266667' AS DateTime2))
INSERT [restaurant_schema].[menuitems] ([menuitem_id], [restaurant_id], [item_name], [description], [price], [rating], [created_at]) VALUES (5, 3, N'Cheese Burger', N'Beef burger', CAST(70.00 AS Decimal(10, 2)), CAST(4.30 AS Decimal(3, 2)), CAST(N'2026-04-22T17:55:56.2266667' AS DateTime2))
INSERT [restaurant_schema].[menuitems] ([menuitem_id], [restaurant_id], [item_name], [description], [price], [rating], [created_at]) VALUES (6, 4, N'Koshary', N'Traditional Egyptian', CAST(30.00 AS Decimal(10, 2)), CAST(4.80 AS Decimal(3, 2)), CAST(N'2026-04-22T17:55:56.2266667' AS DateTime2))
SET IDENTITY_INSERT [restaurant_schema].[menuitems] OFF
GO
SET IDENTITY_INSERT [restaurant_schema].[restaurants] ON 

INSERT [restaurant_schema].[restaurants] ([restaurant_id], [restaurant_name], [address], [phone], [created_at]) VALUES (2, N'Pizza King', N'Cairo', N'01111111111', CAST(N'2026-04-22T17:45:06.4800000' AS DateTime2))
INSERT [restaurant_schema].[restaurants] ([restaurant_id], [restaurant_name], [address], [phone], [created_at]) VALUES (3, N'Burger Hub', N'Giza', N'01222222222', CAST(N'2026-04-22T17:45:06.4800000' AS DateTime2))
INSERT [restaurant_schema].[restaurants] ([restaurant_id], [restaurant_name], [address], [phone], [created_at]) VALUES (4, N'Koshary El Tahrir', N'Cairo', N'01333333333', CAST(N'2026-04-22T17:45:06.4800000' AS DateTime2))
SET IDENTITY_INSERT [restaurant_schema].[restaurants] OFF
GO
SET IDENTITY_INSERT [user_schema].[users] ON 

INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1010, N'Ahmed Ali', N'ahmed@gmail.com', N'01000000001', N'Cairo', CAST(N'2026-04-22T17:40:23.6500000' AS DateTime2))
INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1011, N'Sara Mohamed', N'sara@gmail.com', N'01000000002', N'Giza', CAST(N'2026-04-22T17:40:23.6500000' AS DateTime2))
INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1012, N'Omar Hassan', N'omar@gmail.com', N'01000000003', N'Alex', CAST(N'2026-04-22T17:40:23.6500000' AS DateTime2))
INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1013, N'Mustafa Ragab', N'mustafa@gmail.com', N'1445555554', N'Kfs', CAST(N'2026-04-23T17:44:00.3600000' AS DateTime2))
INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1014, N'mohamed Nour', N'nour@gmail.com', N'1544442456', N'Alex', CAST(N'2026-04-25T17:09:15.2466667' AS DateTime2))
INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1015, N'Heba Ail', N'heba@gmail.com', N'1544444545', N'Giza', CAST(N'2026-04-25T17:09:15.2466667' AS DateTime2))
INSERT [user_schema].[users] ([user_id], [user_name], [email], [phone], [address], [created_at]) VALUES (1016, N'Kaled Ahamd', N'kaled@gmail.com', N'1478942456', N'Cairo', CAST(N'2026-04-25T17:09:15.2466667' AS DateTime2))
SET IDENTITY_INSERT [user_schema].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__delivery__B43B145FD7F2FE55]    Script Date: 4/25/2026 6:25:37 PM ******/
ALTER TABLE [delivery_schema].[delivery_drivers] ADD UNIQUE NONCLUSTERED 
(
	[phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_orderitems_menuitem]    Script Date: 4/25/2026 6:25:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_orderitems_menuitem] ON [order_schema].[order_items]
(
	[menuitem_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_orderitems_order]    Script Date: 4/25/2026 6:25:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_orderitems_order] ON [order_schema].[order_items]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_orders_restaurant]    Script Date: 4/25/2026 6:25:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_orders_restaurant] ON [order_schema].[orders]
(
	[restaurant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_orders_user]    Script Date: 4/25/2026 6:25:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_orders_user] ON [order_schema].[orders]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_menuitems_restaurant]    Script Date: 4/25/2026 6:25:37 PM ******/
CREATE NONCLUSTERED INDEX [idx_menuitems_restaurant] ON [restaurant_schema].[menuitems]
(
	[restaurant_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__AB6E6164023EAD36]    Script Date: 4/25/2026 6:25:37 PM ******/
ALTER TABLE [user_schema].[users] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__B43B145FD96B6453]    Script Date: 4/25/2026 6:25:37 PM ******/
ALTER TABLE [user_schema].[users] ADD UNIQUE NONCLUSTERED 
(
	[phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [delivery_schema].[deliveries] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [delivery_schema].[delivery_drivers] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [order_schema].[orders] ADD  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [order_schema].[orders] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [restaurant_schema].[menuitems] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [restaurant_schema].[restaurants] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [user_schema].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [delivery_schema].[deliveries]  WITH CHECK ADD  CONSTRAINT [fk_deliveries_driver] FOREIGN KEY([driver_id])
REFERENCES [delivery_schema].[delivery_drivers] ([driver_id])
GO
ALTER TABLE [delivery_schema].[deliveries] CHECK CONSTRAINT [fk_deliveries_driver]
GO
ALTER TABLE [delivery_schema].[deliveries]  WITH CHECK ADD  CONSTRAINT [fk_deliveries_order] FOREIGN KEY([order_id])
REFERENCES [order_schema].[orders] ([order_id])
GO
ALTER TABLE [delivery_schema].[deliveries] CHECK CONSTRAINT [fk_deliveries_order]
GO
ALTER TABLE [order_schema].[order_items]  WITH CHECK ADD  CONSTRAINT [fk_orderitems_menuitem] FOREIGN KEY([menuitem_id])
REFERENCES [restaurant_schema].[menuitems] ([menuitem_id])
GO
ALTER TABLE [order_schema].[order_items] CHECK CONSTRAINT [fk_orderitems_menuitem]
GO
ALTER TABLE [order_schema].[order_items]  WITH CHECK ADD  CONSTRAINT [fk_orderitems_order] FOREIGN KEY([order_id])
REFERENCES [order_schema].[orders] ([order_id])
ON DELETE CASCADE
GO
ALTER TABLE [order_schema].[order_items] CHECK CONSTRAINT [fk_orderitems_order]
GO
ALTER TABLE [order_schema].[orders]  WITH CHECK ADD  CONSTRAINT [fk_orders_restaurant] FOREIGN KEY([restaurant_id])
REFERENCES [restaurant_schema].[restaurants] ([restaurant_id])
GO
ALTER TABLE [order_schema].[orders] CHECK CONSTRAINT [fk_orders_restaurant]
GO
ALTER TABLE [order_schema].[orders]  WITH CHECK ADD  CONSTRAINT [fk_orders_user] FOREIGN KEY([user_id])
REFERENCES [user_schema].[users] ([user_id])
GO
ALTER TABLE [order_schema].[orders] CHECK CONSTRAINT [fk_orders_user]
GO
ALTER TABLE [restaurant_schema].[menuitems]  WITH CHECK ADD  CONSTRAINT [fk_menuitems_restaurant] FOREIGN KEY([restaurant_id])
REFERENCES [restaurant_schema].[restaurants] ([restaurant_id])
ON DELETE CASCADE
GO
ALTER TABLE [restaurant_schema].[menuitems] CHECK CONSTRAINT [fk_menuitems_restaurant]
GO
ALTER TABLE [delivery_schema].[deliveries]  WITH CHECK ADD  CONSTRAINT [chk_delivery_status] CHECK  (([status]='Delivered' OR [status]='OnTheWay' OR [status]='Picked' OR [status]='Assigned'))
GO
ALTER TABLE [delivery_schema].[deliveries] CHECK CONSTRAINT [chk_delivery_status]
GO
ALTER TABLE [order_schema].[order_items]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
ALTER TABLE [order_schema].[orders]  WITH CHECK ADD  CONSTRAINT [chk_order_status] CHECK  (([status]='Cancelled' OR [status]='Delivered' OR [status]='Preparing' OR [status]='Confirmed' OR [status]='Pending'))
GO
ALTER TABLE [order_schema].[orders] CHECK CONSTRAINT [chk_order_status]
GO
USE [master]
GO
ALTER DATABASE [Food Delivery] SET  READ_WRITE 
GO
