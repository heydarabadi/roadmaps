// Run only against the disposable learning database; this script deletes and rebuilds sample collections.
// Persian names and labels are intentional so you can practice Unicode and Persian search.
db = db.getSiblingDB("learning")
db.products.deleteMany({})
db.customers.deleteMany({})
db.orders.deleteMany({})

db.customers.insertMany([
  { _id: "C-100", name: "سارا", city: "تهران", createdAt: ISODate("2026-10-01T09:00:00Z") },
  { _id: "C-200", name: "رضا", city: "شیراز", createdAt: ISODate("2026-10-02T09:00:00Z") }
])

db.products.insertMany([
  { sku: "KB-01", title: "صفحه‌کلید فارسی", price: NumberDecimal("45.00"), stock: 12, active: true, tags: ["ورودی", "فارسی"] },
  { sku: "MS-01", title: "ماوس بی‌سیم", price: NumberDecimal("18.50"), stock: 0, active: true, tags: ["بی‌سیم"] },
  { sku: "HD-01", title: "هدفون", price: NumberDecimal("72.00"), stock: 7, active: true, tags: ["صدا"] },
  { sku: "OLD-01", title: "مدل قدیمی", price: NumberDecimal("9.99"), stock: 0, active: false, tags: [] }
])

db.orders.insertMany([
  { _id: "O-100", customerId: "C-100", status: "paid", createdAt: ISODate("2026-11-01T10:00:00Z"), items: [{ sku: "KB-01", qty: 1, unitPrice: NumberDecimal("45.00") }], total: NumberDecimal("45.00") },
  { _id: "O-101", customerId: "C-100", status: "open", createdAt: ISODate("2026-11-02T10:00:00Z"), items: [{ sku: "MS-01", qty: 2, unitPrice: NumberDecimal("18.50") }], total: NumberDecimal("37.00"), note: null },
  { _id: "O-200", customerId: "C-200", status: "shipped", createdAt: ISODate("2026-11-03T10:00:00Z"), items: [{ sku: "HD-01", qty: 1, unitPrice: NumberDecimal("72.00") }, { sku: "KB-01", qty: 1, unitPrice: NumberDecimal("45.00") }], total: NumberDecimal("117.00") },
  { _id: "O-201", customerId: "C-200", status: "cancelled", createdAt: ISODate("2026-11-04T10:00:00Z"), items: [], total: NumberDecimal("0.00") }
])
print("Practice data for the learning database is ready.")
