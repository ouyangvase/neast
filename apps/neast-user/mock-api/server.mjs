import http from 'node:http';
import { URL } from 'node:url';

const PORT = Number(process.env.PORT || 8000);
const DEMO_PHONE = '60123456789';
const DEMO_OTP = '123456';

const merchantCategories = [
  { id: 1, name: 'Food' },
  { id: 2, name: 'Retail' },
  { id: 3, name: 'Services' },
  { id: 4, name: 'Groceries' },
];

const merchants = [
  {
    id: 1,
    name: 'Nasi Lemak House',
    address: 'Jalan Indah 15, Bukit Indah',
    image: 'https://picsum.photos/seed/neast-food-1/200/200',
    latitude: 1.4871,
    longitude: 103.6578,
    category_id: 1,
    special_deal: 'Earn 5X points',
    min_spend: '20',
  },
  {
    id: 2,
    name: 'Southkey Kopitiam',
    address: 'Southkey Mosaic, Johor Bahru',
    image: 'https://picsum.photos/seed/neast-food-2/200/200',
    latitude: 1.5314,
    longitude: 103.7796,
    category_id: 1,
    special_deal: 'Earn 3X points',
    min_spend: '15',
  },
  {
    id: 3,
    name: 'Indah Mini Mart',
    address: 'Jalan Indah 12, Bukit Indah',
    image: 'https://picsum.photos/seed/neast-retail-1/200/200',
    latitude: 1.4854,
    longitude: 103.6549,
    category_id: 2,
    special_deal: 'Earn 2X points',
    min_spend: '10',
  },
  {
    id: 4,
    name: 'Park Avenue Fashion',
    address: 'The Park Residence, Johor Bahru',
    image: 'https://picsum.photos/seed/neast-retail-2/200/200',
    latitude: 1.4932,
    longitude: 103.7418,
    category_id: 2,
    special_deal: 'Earn 4X points',
    min_spend: '50',
  },
  {
    id: 5,
    name: 'QuickWash Laundry',
    address: 'Jalan Indah 8, Bukit Indah',
    image: 'https://picsum.photos/seed/neast-service-1/200/200',
    latitude: 1.4841,
    longitude: 103.6592,
    category_id: 3,
    special_deal: 'Earn 5X points',
    min_spend: '25',
  },
  {
    id: 6,
    name: 'Fresh Mart Grocery',
    address: 'AEON Bukit Indah',
    image: 'https://picsum.photos/seed/neast-grocery-1/200/200',
    latitude: 1.4886,
    longitude: 103.6624,
    category_id: 4,
    special_deal: 'Earn 3X points',
    min_spend: '30',
  },
  {
    id: 7,
    name: 'Indah Cafe',
    address: 'Jalan Indah 16, Bukit Indah',
    image: 'https://picsum.photos/seed/neast-food-3/200/200',
    latitude: 1.4838,
    longitude: 103.655,
    category_id: 1,
    special_deal: 'Earn 5X points',
    min_spend: '18',
  },
  {
    id: 8,
    name: 'Glow Pharmacy',
    address: 'Jalan Indah 10, Bukit Indah',
    image: 'https://picsum.photos/seed/neast-retail-3/200/200',
    latitude: 1.489,
    longitude: 103.654,
    category_id: 2,
    special_deal: 'Earn 5X points',
    min_spend: '15',
  },
  {
    id: 9,
    name: 'Bubble Lab',
    address: 'Jalan Indah 21, Bukit Indah',
    image: 'https://picsum.photos/seed/neast-food-4/200/200',
    latitude: 1.4878,
    longitude: 103.6605,
    category_id: 1,
    special_deal: 'Earn 5X points',
    min_spend: '12',
  },
];

function haversineKm(lat1, lon1, lat2, lon2) {
  const toRad = (value) => (value * Math.PI) / 180;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
  return 6371 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function merchantPayload(item, latitude, longitude) {
  const hasPoint = Number.isFinite(latitude) && Number.isFinite(longitude);
  return {
    ...item,
    distance: hasPoint
      ? Number(haversineKm(latitude, longitude, item.latitude, item.longitude).toFixed(2))
      : 0,
  };
}

function listMerchants(url) {
  const latitude = Number(url.searchParams.get('latitude'));
  const longitude = Number(url.searchParams.get('longitude'));
  const categoryId = url.searchParams.get('category_id');
  const page = Number(url.searchParams.get('page') || 1);
  const limit = Number(url.searchParams.get('limit') || 20);
  const selectedId = categoryId == null ? null : Number(categoryId);
  const filtered = selectedId == null
    ? merchants
    : selectedId === 5
      ? merchants.filter((item) => String(item.special_deal || '').includes('5X'))
      : merchants.filter((item) => item.category_id === selectedId);
  const items = filtered.map((item) => merchantPayload(item, latitude, longitude));
  const start = (page - 1) * limit;
  return {
    items: items.slice(start, start + limit),
    total: items.length,
    page,
    limit,
  };
}

const properties = [
  {
    id: 101,
    sn: 'NEAST-BUKIT-01',
    name: 'Bukit Indah Apartment',
    landlord_id: 10,
    landlord_name: 'Alex Tan',
    landlord_bank_name: 'Maybank',
    landlord_bank_last4: '8890',
    landlord_account_name: 'Alex Tan',
  },
  {
    id: 102,
    sn: 'NEAST-PARK-02',
    name: 'The Park Residence',
    landlord_id: 11,
    landlord_name: 'Sarah Lim',
    landlord_bank_name: 'CIMB',
    landlord_bank_last4: '4412',
    landlord_account_name: 'Sarah Lim',
  },
];

function seedRents() {
  return [
    {
      id: 1,
      amount: '1800',
      file: 'demo/agreement.pdf',
      file_url: '',
      paid_at: 1,
      first_pay_month: '2026-09',
      lease_months: 12,
      expire_date: '2027-08-31',
      status: 1,
      landlord_id: 10,
      landlord_name: 'Alex Tan',
      landlord_account_name: 'Alex Tan',
      landlord_bank_name: 'Maybank',
      landlord_bank_last4: '8890',
      property_name: 'Bukit Indah Apartment',
      earn_points: 180,
      created_at: '2026-09-01',
      can_pay: true,
      due_text: 'Due in 12 days',
      date_label: '1 Oct 2026',
      payout_status: '',
      invite_sent: false,
    },
    {
      id: 2,
      amount: '1600',
      file: 'demo/agreement.pdf',
      file_url: '',
      paid_at: 5,
      first_pay_month: '2026-09',
      lease_months: 12,
      expire_date: '2027-08-31',
      status: 1,
      landlord_id: null,
      landlord_name: 'Lim Wei',
      landlord_account_name: '',
      landlord_bank_name: '',
      landlord_bank_last4: '',
      property_name: 'Southkey Suites',
      earn_points: 160,
      created_at: '2026-09-01',
      can_pay: true,
      due_text: 'Due in 16 days',
      date_label: '5 Oct 2026',
      payout_status: '',
      invite_sent: false,
    },
  ];
}

const db = {
  users: new Map(),
  nextRentId: 3,
  nextHistoryId: 1,
};

function demoUser() {
  return {
    userId: '1001',
    account: DEMO_PHONE,
    email: 'alex.demo@neast.local',
    firstName: 'Alex',
    lastName: 'Demo',
    idType: 'id_card',
    idNumber: '900101145678',
    idValidUntil: null,
    address: 'Johor Bahru',
    profileCompleted: true,
    points: 420,
    pointsApproxRm: 4.2,
    qrCode: JSON.stringify({ user_id: 1001 }),
    accessToken: 'demo-access-1001',
    refreshToken: 'demo-refresh-1001',
    wallet: 2000,
    rents: seedRents(),
    history: [],
  };
}

function emptyUser(account) {
  const id = String(2000 + db.users.size);
  return {
    userId: id,
    account,
    email: '',
    firstName: 'Demo',
    lastName: 'Tenant',
    idType: 'id_card',
    idNumber: '',
    idValidUntil: null,
    address: '',
    profileCompleted: true,
    points: 0,
    pointsApproxRm: 0,
    qrCode: JSON.stringify({ user_id: Number(id) }),
    accessToken: `demo-access-${id}`,
    refreshToken: `demo-refresh-${id}`,
    wallet: 500,
    rents: [],
    history: [],
  };
}

db.users.set(DEMO_PHONE, demoUser());

function ok(res, data = {}) {
  json(res, 200, { code: 200, message: 'ok', data });
}

function fail(res, message, code = 401) {
  json(res, 200, { code, message, data: null });
}

function json(res, status, body) {
  const payload = JSON.stringify(body);
  res.writeHead(status, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Authorization, Content-Type',
    'Access-Control-Allow-Methods': 'GET,POST,PUT,OPTIONS',
  });
  res.end(payload);
}

function html(res, body) {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(body);
}

async function readBody(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  const raw = Buffer.concat(chunks).toString('utf8');
  if (!raw) return {};
  try {
    return JSON.parse(raw);
  } catch {
    return { raw };
  }
}

function userFromAuth(req) {
  const token = String(req.headers.authorization || '').trim();
  if (!token) return null;
  for (const user of db.users.values()) {
    if (user.accessToken === token) return user;
  }
  return null;
}

function requireUser(req, res) {
  const user = userFromAuth(req);
  if (!user) {
    fail(res, 'Login required', 401);
    return null;
  }
  return user;
}

function publicRent(rent) {
  return { ...rent };
}

function payableRent(user) {
  return user.rents.find((rent) => rent.can_pay && rent.status === 1) || null;
}

function settlePayment(user, rent, method, extra = {}) {
  const now = new Date();
  const stamp = now.toISOString().slice(0, 19).replace('T', ' ');
  const last4 = extra.landlord_bank_last4 || rent.landlord_bank_last4 || '';
  const payoutStatus = rent.landlord_id ? 'queued' : 'held';

  if (extra.landlord_bank_name) rent.landlord_bank_name = extra.landlord_bank_name;
  if (last4) rent.landlord_bank_last4 = last4;
  if (extra.landlord_account_name) {
    rent.landlord_account_name = extra.landlord_account_name;
    if (!rent.landlord_name) rent.landlord_name = extra.landlord_account_name;
  }
  rent.payout_status = payoutStatus;
  rent.can_pay = false;

  const item = {
    id: db.nextHistoryId++,
    rent_id: rent.id,
    last_paid_date: stamp.slice(0, 10),
    user_paid_at: stamp,
    status: 1,
    display_status: 'paid',
    pay_status: 'on_time',
    amount: rent.amount,
    property_address: rent.property_name,
    landlord_account_name: rent.landlord_account_name || rent.landlord_name,
    landlord_name: rent.landlord_name,
    landlord_id: rent.landlord_id,
    landlord_bank_last4: rent.landlord_bank_last4,
    payment_method: method,
    payment_no: `NEAST${now.getTime()}`,
    rental_period: 'September 2026',
    payout_status: payoutStatus,
  };
  user.history.unshift(item);
  return item;
}

function goldTier() {
  return {
    id: 1,
    name: 'Gold',
    min_points: 0,
    max_points: 9999999,
  };
}

const server = http.createServer(async (req, res) => {
  if (req.method === 'OPTIONS') {
    json(res, 204, { code: 200, message: 'ok', data: {} });
    return;
  }

  const url = new URL(req.url || '/', `http://${req.headers.host}`);
  const path = url.pathname;
  const method = req.method || 'GET';

  try {
    if (path === '/pay_success.html') {
      html(res, '<html><body>pay_success</body></html>');
      return;
    }

    if (path === '/app/auth/country-codes' && method === 'GET') {
      ok(res, [{ code: '+60' }, { code: '+65' }]);
      return;
    }

    if (path === '/app/auth/send-code' && method === 'POST') {
      ok(res, { sent: true });
      return;
    }

    if (path === '/app/auth/login' && method === 'POST') {
      const body = await readBody(req);
      const account = String(body.account || '').replace(/\D/g, '');
      const code = String(body.code || '');
      if (code !== DEMO_OTP) {
        fail(res, 'Invalid code', 401);
        return;
      }
      if (!db.users.has(account)) {
        db.users.set(account, emptyUser(account));
      }
      const user = db.users.get(account);
      ok(res, {
        userId: user.userId,
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        expiresTime: Date.now() + 7 * 24 * 60 * 60 * 1000,
        profileCompleted: user.profileCompleted,
      });
      return;
    }

    if (path === '/app/auth/refresh-token' && method === 'POST') {
      const refreshToken = url.searchParams.get('refreshToken') || '';
      const user = [...db.users.values()].find((item) => item.refreshToken === refreshToken);
      if (!user) {
        fail(res, 'Invalid refresh token', 400);
        return;
      }
      ok(res, {
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        expiresTime: Date.now() + 7 * 24 * 60 * 60 * 1000,
      });
      return;
    }

    if (path === '/app/user/profile' && method === 'GET') {
      const user = requireUser(req, res);
      if (!user) return;
      ok(res, {
        userId: user.userId,
        account: user.account,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        idType: user.idType,
        idNumber: user.idNumber,
        idValidUntil: user.idValidUntil,
        address: user.address,
        profileCompleted: user.profileCompleted,
        points: user.points,
        pointsApproxRm: user.pointsApproxRm,
        qrCode: user.qrCode,
      });
      return;
    }

    if (path === '/app/user/profile' && method === 'POST') {
      const user = requireUser(req, res);
      if (!user) return;
      const body = await readBody(req);
      Object.assign(user, {
        firstName: body.first_name || user.firstName,
        lastName: body.last_name || user.lastName,
        email: body.email || user.email,
        address: body.address || user.address,
        profileCompleted: true,
      });
      ok(res, {});
      return;
    }

    if (path === '/app/user/delete-account' && method === 'POST') {
      ok(res, {});
      return;
    }

    if (path === '/app/home/dashboard' && method === 'GET') {
      const user = requireUser(req, res);
      if (!user) return;
      ok(res, {
        nextRent: payableRent(user),
        todayReward: null,
        nearbyDeals: merchants.slice(0, 4).map((item) => merchantPayload(item)),
        journey: {
          maxStreakMonths: 3,
          streakLabel: '3-month streak',
          streakStatus: 'On time',
        },
        banners: [],
      });
      return;
    }

    if (path === '/app/reward/dashboard' && method === 'GET') {
      const user = userFromAuth(req);
      ok(res, {
        points: user?.points ?? 0,
        pointsExpiringText: '',
        tier: {
          current: goldTier(),
          next: null,
          pointsToNextTier: 0,
          progressCurrent: user?.points ?? 0,
          progressTarget: 1000,
        },
        tiers: [goldTier()],
        featuredRewards: [],
        nearbyRewards: merchants.slice(0, 3).map((item) => merchantPayload(item)),
      });
      return;
    }

    if (path === '/app/points/dashboard' && method === 'GET') {
      const user = requireUser(req, res);
      if (!user) return;
      ok(res, {
        points: user.points,
        tier: { current: goldTier() },
        voucher_count: 0,
        inviter_reward_points: 200,
        invitee_reward_points: 50,
      });
      return;
    }

    if (path === '/app/points/logs' && method === 'GET') {
      ok(res, { items: [], total: 0, page: 1, limit: 20 });
      return;
    }

    if (path === '/app/refer/dashboard' && method === 'GET') {
      ok(res, {
        total_earned_points: 0,
        invited_count: 0,
        max_invite_limit: 4,
        next_reward_points: 200,
        invitation_code: 'NEASTDEMO',
        invitee_reward_points: 50,
        invite_url: 'https://neast.my/r/NEASTDEMO',
      });
      return;
    }

    if (path === '/app/user/tent-score' && method === 'GET') {
      ok(res, {
        score: 820,
        maxScore: 1000,
        ratingLabel: 'Good',
        streakLabel: '3 months',
        streakStatus: 'On time',
        onTimePayments: 3,
        latePayments: 0,
        totalPaid: '5400',
        verifiedLeases: 1,
        since: '2026-07',
      });
      return;
    }

    if (path === '/app/wallet/balance' && method === 'GET') {
      const user = requireUser(req, res);
      if (!user) return;
      ok(res, { balance: user.wallet.toFixed(2) });
      return;
    }

    if (path === '/app/wallet/topup/list' && method === 'GET') {
      ok(res, { items: [], total: 0, page: 1, limit: 10 });
      return;
    }

    if (path === '/app/wallet/topup/create' && method === 'POST') {
      ok(res, {
        order_id: `topup-${Date.now()}`,
        payment_url: 'http://10.0.2.2:8000/pay_success.html',
      });
      return;
    }

    if (path === '/app/payment/quote' && method === 'GET') {
      ok(res, { fee: '0', amount: url.searchParams.get('amount') || '0' });
      return;
    }

    if (path === '/app/rent/list' && method === 'GET') {
      const user = requireUser(req, res);
      if (!user) return;
      ok(res, {
        items: user.rents.map(publicRent),
        total: user.rents.length,
        page: 1,
        limit: 20,
        rent_points_multiplier: 1,
      });
      return;
    }

    if (path === '/app/rent/connect-options' && method === 'GET') {
      ok(res, {
        items: properties.map((item) => ({
          id: item.id,
          sn: item.sn,
          name: item.name,
          landlord_name: item.landlord_name,
        })),
      });
      return;
    }

    if (path === '/app/rent/property' && method === 'GET') {
      const sn = String(url.searchParams.get('sn') || '').trim();
      const property = properties.find((item) => item.sn === sn);
      if (!property) {
        fail(res, 'Property not found', 404);
        return;
      }
      ok(res, {
        id: property.id,
        name: property.name,
        landlord_name: property.landlord_name,
      });
      return;
    }

    if (path === '/app/rent/create' && method === 'POST') {
      const user = requireUser(req, res);
      if (!user) return;
      const body = await readBody(req);
      const property = properties.find((item) => item.id === Number(body.property_id));
      const rent = {
        id: db.nextRentId++,
        amount: String(body.amount ?? '0'),
        file: body.file || '',
        file_url: '',
        paid_at: Number(body.paid_at || 1),
        first_pay_month: body.first_pay_month || '2026-09',
        lease_months: Number(body.lease_months || 12),
        expire_date: '2027-08-31',
        status: 1,
        landlord_id: property?.landlord_id ?? null,
        landlord_name: property?.landlord_name || body.owner_name || '',
        landlord_account_name: property?.landlord_account_name || '',
        landlord_bank_name: property?.landlord_bank_name || '',
        landlord_bank_last4: property?.landlord_bank_last4 || '',
        property_name: property?.name || body.property_name || 'My Tenancy',
        earn_points: 0,
        created_at: new Date().toISOString().slice(0, 10),
        can_pay: true,
        due_text: 'Due this month',
        date_label: '1 Oct 2026',
        payout_status: '',
        invite_sent: false,
      };
      user.rents.unshift(rent);
      ok(res, publicRent(rent));
      return;
    }

    if (path === '/app/rent/history/list' && method === 'GET') {
      const user = requireUser(req, res);
      if (!user) return;
      const rentId = Number(url.searchParams.get('rent_id') || 0);
      const items = rentId
        ? user.history.filter((item) => item.rent_id === rentId)
        : user.history;
      ok(res, { items, total: items.length, page: 1, limit: 15 });
      return;
    }

    if (path === '/app/rent/pay/wallet' && method === 'POST') {
      const user = requireUser(req, res);
      if (!user) return;
      const body = await readBody(req);
      const rent = user.rents.find((item) => item.id === Number(body.rent_id));
      if (!rent) {
        fail(res, 'Tenancy not found', 404);
        return;
      }
      const amount = Number(rent.amount);
      if (user.wallet < amount) {
        fail(res, 'Insufficient wallet balance', 422);
        return;
      }
      user.wallet -= amount;
      const last4 = body.owner_bank_account
        ? String(body.owner_bank_account).slice(-4)
        : rent.landlord_bank_last4;
      ok(
        res,
        settlePayment(user, rent, 'wallet', {
          landlord_bank_name: body.owner_bank_name,
          landlord_bank_last4: last4,
          landlord_account_name: body.owner_account_holder,
        }),
      );
      return;
    }

    if (path === '/app/rent/pay/create' && method === 'POST') {
      const user = requireUser(req, res);
      if (!user) return;
      const body = await readBody(req);
      const rent = user.rents.find((item) => item.id === Number(body.rent_id));
      if (!rent) {
        fail(res, 'Tenancy not found', 404);
        return;
      }
      const last4 = body.owner_bank_account
        ? String(body.owner_bank_account).slice(-4)
        : rent.landlord_bank_last4;
      const history = settlePayment(user, rent, body.payment_method || 'fpx', {
        landlord_bank_name: body.owner_bank_name,
        landlord_bank_last4: last4,
        landlord_account_name: body.owner_account_holder,
      });
      ok(res, {
        order_id: `order-${history.id}`,
        payment_url: '',
        history_id: history.id,
      });
      return;
    }

    if (path === '/app/rent/invite' && method === 'POST') {
      const user = requireUser(req, res);
      if (!user) return;
      const body = await readBody(req);
      const rent = user.rents.find((item) => item.id === Number(body.rent_id));
      if (rent) {
        rent.invite_sent = true;
        rent.payout_status = 'invited';
        if (body.name) rent.landlord_name = body.name;
      }
      const history = user.history.find((item) => item.id === Number(body.history_id));
      if (history) history.payout_status = 'invited';
      ok(res, { sent: true });
      return;
    }

    if (path.startsWith('/app/rent/id/') && method === 'PUT') {
      const user = requireUser(req, res);
      if (!user) return;
      const id = Number(path.split('/')[4]);
      const rent = user.rents.find((item) => item.id === id);
      if (rent) {
        rent.status = 4;
        rent.can_pay = false;
      }
      ok(res, {});
      return;
    }

    if (path.startsWith('/app/upload/') && method === 'POST') {
      await readBody(req);
      ok(res, { path: `uploads/demo-${Date.now()}.pdf` });
      return;
    }

    if (path === '/app/message/list' && method === 'GET') {
      ok(res, { items: [], total: 0, page: 1, limit: 15 });
      return;
    }

    if (path === '/app/message/read-all' && method === 'POST') {
      ok(res, {});
      return;
    }

    if (path === '/app/message/has-unread' && method === 'GET') {
      ok(res, { has_unread: false });
      return;
    }

    if (path === '/app/agreement/detail' && method === 'GET') {
      ok(res, { title: url.searchParams.get('title') || '', content: '<p>Demo legal copy.</p>' });
      return;
    }

    if (path === '/app/config' && method === 'GET') {
      ok(res, { alpha: false });
      return;
    }

    if (path === '/app/coupon/categories' && method === 'GET') {
      ok(res, { items: [] });
      return;
    }

    if (path === '/app/coupon/latest' && method === 'GET') {
      ok(res, null);
      return;
    }

    if (
      (path === '/app/coupon/list' ||
        path === '/app/coupon/my-list' ||
        path === '/app/coupon/merchant-list') &&
      method === 'GET'
    ) {
      ok(res, { items: [], total: 0, page: 1, limit: 20 });
      return;
    }

    if (path === '/app/coupon/my-count' && method === 'GET') {
      ok(res, { count: 0 });
      return;
    }

    if (path === '/app/coupon/redeem' && method === 'POST') {
      fail(res, 'Demo catalog only', 422);
      return;
    }

    if (path === '/app/merchant/categories' && method === 'GET') {
      ok(res, { items: merchantCategories });
      return;
    }

    if (
      (path === '/app/merchant/list' ||
        path === '/app/merchant/recommended' ||
        path === '/app/merchant/nearby/list' ||
        path === '/app/merchant/nearby') &&
      method === 'GET'
    ) {
      ok(res, listMerchants(url));
      return;
    }

    if (path === '/app/merchant/detail' && method === 'GET') {
      const merchant = merchants.find((item) => item.id === Number(url.searchParams.get('id')));
      if (!merchant) {
        fail(res, 'Merchant not found', 404);
        return;
      }
      const latitude = Number(url.searchParams.get('latitude'));
      const longitude = Number(url.searchParams.get('longitude'));
      const nearest = merchants.find((item) => item.id !== merchant.id);
      ok(res, {
        ...merchantPayload(merchant, latitude, longitude),
        nearest_merchant: nearest ? merchantPayload(nearest, latitude, longitude) : null,
      });
      return;
    }

    if (path === '/app/push/add-fcm-token' || path === '/app/push/delete-fcm-token') {
      ok(res, {});
      return;
    }

    fail(res, `No mock for ${method} ${path}`, 404);
  } catch (error) {
    fail(res, error instanceof Error ? error.message : 'Server error', 500);
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`NEAST mock /app API on http://0.0.0.0:${PORT}`);
  console.log(`Demo sign-in: +60 123456789  OTP ${DEMO_OTP}`);
});
