import React, { useState, useEffect, useCallback } from 'react';
import { Home, Users, Building2, DollarSign, Wrench, Search, Plus, AlertCircle, CheckCircle, Clock, X, Sun, Moon, Settings, Menu, LogOut, LockKeyhole, Trash2 } from 'lucide-react';

const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:4000';
const AUTH_STORAGE_KEY = 'auca-dorm-admin-authenticated';
const DEFAULT_ADMIN = {
  username: 'admin',
  password: 'admin123',
};
const deleteButtonClass =
  'inline-flex h-9 min-w-[92px] items-center justify-center gap-2 rounded-lg bg-red-600 px-3 text-sm font-semibold leading-none text-white shadow-sm transition-colors duration-150 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-300 dark:bg-red-500 dark:text-white dark:hover:bg-red-600';
const compactDeleteButtonClass =
  'inline-flex h-8 min-w-[78px] items-center justify-center gap-1.5 rounded-md bg-red-600 px-2.5 text-xs font-semibold leading-none text-white shadow-sm transition-colors duration-150 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-300 dark:bg-red-500 dark:text-white dark:hover:bg-red-600';
const maintenanceDeleteButtonClass = compactDeleteButtonClass;

const getStoredAuth = () => {
  try {
    return window.localStorage.getItem(AUTH_STORAGE_KEY) === 'true';
  } catch {
    return false;
  }
};

const Modal = ({ title, onClose, onSubmit, actionLabel = 'Save', children }) => (
  <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50">
    <div className="bg-white rounded-lg shadow-lg w-full max-w-lg p-6 relative">
      <button className="absolute top-3 right-3 text-gray-500 hover:text-gray-700" onClick={onClose} aria-label="Close">
        <X size={18} />
      </button>
      <h3 className="text-xl font-semibold mb-4">{title}</h3>
      <div className="space-y-3">{children}</div>
      <div className="mt-6 flex justify-end gap-2">
        <button onClick={onClose} className="px-4 py-2 rounded-lg border border-gray-300 text-gray-700 hover:bg-gray-100">Cancel</button>
        <button onClick={onSubmit} className="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700">{actionLabel}</button>
      </div>
    </div>
  </div>
);

const LoginScreen = ({ form, error, onChange, onSubmit }) => (
  <main className="min-h-screen bg-[#dbeafe] text-slate-900 flex items-center justify-center px-4 py-10">
    <section className="w-full max-w-md bg-white border border-blue-100 rounded-lg shadow-xl p-8">
      <div className="flex items-center gap-3 mb-8">
        <div className="h-12 w-12 rounded-lg bg-blue-600 text-white flex items-center justify-center">
          <LockKeyhole size={24} />
        </div>
        <div>
          <p className="text-2xl font-bold leading-tight">AUCA Dorm</p>
          <p className="text-sm text-slate-500">Admin access</p>
        </div>
      </div>

      <form onSubmit={onSubmit} className="space-y-5">
        <div>
          <label htmlFor="admin-username" className="block text-sm font-medium text-slate-700 mb-1">
            Admin username
          </label>
          <input
            id="admin-username"
            type="text"
            autoComplete="username"
            value={form.username}
            onChange={(event) => onChange({ ...form, username: event.target.value })}
            className="w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-slate-900 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
            placeholder="admin"
          />
        </div>

        <div>
          <label htmlFor="admin-password" className="block text-sm font-medium text-slate-700 mb-1">
            Password
          </label>
          <input
            id="admin-password"
            type="password"
            autoComplete="current-password"
            value={form.password}
            onChange={(event) => onChange({ ...form, password: event.target.value })}
            className="w-full rounded-lg border border-slate-300 bg-white px-3 py-2.5 text-slate-900 outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
            placeholder="admin123"
          />
        </div>

        {error && (
          <p className="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
            {error}
          </p>
        )}

        <button
          type="submit"
          className="w-full rounded-lg bg-blue-600 px-4 py-3 font-semibold text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300"
        >
          Login
        </button>
      </form>

      <div className="mt-6 rounded-lg bg-slate-50 border border-slate-200 px-4 py-3 text-sm text-slate-600">
        Default access: <span className="font-semibold text-slate-900">admin</span> / <span className="font-semibold text-slate-900">admin123</span>
      </div>
    </section>
  </main>
);

const DormManagementSystem = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(getStoredAuth);
  const [loginForm, setLoginForm] = useState({ username: '', password: '' });
  const [loginError, setLoginError] = useState('');
  const [activeTab, setActiveTab] = useState('dashboard');
  const [searchTerm, setSearchTerm] = useState('');
  const [students, setStudents] = useState([]);
  const [rooms, setRooms] = useState([]);
  const [payments, setPayments] = useState([]);
  const [maintenance, setMaintenance] = useState([]);
  const [deletedStudents, setDeletedStudents] = useState([]);
  const [deletedRooms, setDeletedRooms] = useState([]);
  const [deletedPayments, setDeletedPayments] = useState([]);
  const [deletedMaintenance, setDeletedMaintenance] = useState([]);
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [theme, setTheme] = useState('light');
  const [showStudentForm, setShowStudentForm] = useState(false);
  const [showRoomForm, setShowRoomForm] = useState(false);
  const [showPaymentForm, setShowPaymentForm] = useState(false);
  const [showMaintenanceForm, setShowMaintenanceForm] = useState(false);
  const [mobileNavOpen, setMobileNavOpen] = useState(false);

  const [studentForm, setStudentForm] = useState({ full_name: '', email: '', phone: '', gender: '' });
  const [roomForm, setRoomForm] = useState({ building_id: '', room_type_id: '', room_no: '', status: 'available' });
  const [paymentForm, setPaymentForm] = useState({
    student_id: '',
    amount: '',
    period_start: '',
    period_end: '',
    method: 'cash',
    status: 'pending',
  });
  const [maintenanceForm, setMaintenanceForm] = useState({
    room_id: '',
    student_id: '',
    category: '',
    priority: 'medium',
    status: 'open',
    description: '',
  });

  const fetchJson = useCallback(async (path, options = {}) => {
    const res = await fetch(`${API_BASE}${path}`, options);
    if (!res.ok) {
      const message = await res.text();
      throw new Error(message || `Request failed: ${res.status}`);
    }
    return res.json();
  }, []);

  const loadData = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      if (activeTab === 'dashboard') {
        const [statsData, maintData, payData] = await Promise.all([
          fetchJson('/api/stats'),
          fetchJson('/api/maintenance'),
          fetchJson('/api/payments'),
        ]);
        setStats(statsData);
        setMaintenance(maintData);
        setPayments(payData);
      } else if (activeTab === 'students') {
        const query = searchTerm ? `?q=${encodeURIComponent(searchTerm)}` : '';
        setStudents(await fetchJson(`/api/students${query}`));
      } else if (activeTab === 'rooms') {
        const query = searchTerm ? `?q=${encodeURIComponent(searchTerm)}` : '';
        setRooms(await fetchJson(`/api/rooms${query}`));
      } else if (activeTab === 'payments') {
        const query = searchTerm ? `?q=${encodeURIComponent(searchTerm)}` : '';
        setPayments(await fetchJson(`/api/payments${query}`));
      } else if (activeTab === 'maintenance') {
        const query = searchTerm ? `?q=${encodeURIComponent(searchTerm)}` : '';
        setMaintenance(await fetchJson(`/api/maintenance${query}`));
      } else if (activeTab === 'recovery') {
        const [s, r, p, m] = await Promise.all([
          fetchJson('/api/students?deleted=true'),
          fetchJson('/api/rooms?deleted=true'),
          fetchJson('/api/payments?deleted=true'),
          fetchJson('/api/maintenance?deleted=true'),
        ]);
        setDeletedStudents(s);
        setDeletedRooms(r);
        setDeletedPayments(p);
        setDeletedMaintenance(m);
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }, [activeTab, searchTerm, fetchJson]);

  useEffect(() => {
    if (isAuthenticated) {
      loadData();
    }
  }, [isAuthenticated, loadData]);

  useEffect(() => {
    const isDarkMode = theme === 'dark';
    document.documentElement.classList.toggle('dark', isDarkMode);
    document.body.className = isDarkMode ? 'bg-slate-900 text-slate-100' : 'bg-slate-100 text-slate-900';
  }, [theme]);

  const handleLogin = (event) => {
    event.preventDefault();
    const username = loginForm.username.trim();
    if (username === DEFAULT_ADMIN.username && loginForm.password === DEFAULT_ADMIN.password) {
      try {
        window.localStorage.setItem(AUTH_STORAGE_KEY, 'true');
      } catch {
        // Continue with in-memory login if browser storage is unavailable.
      }
      setIsAuthenticated(true);
      setLoginError('');
      setLoginForm({ username: '', password: '' });
      return;
    }
    setLoginError('Invalid admin username or password.');
  };

  const handleLogout = () => {
    try {
      window.localStorage.removeItem(AUTH_STORAGE_KEY);
    } catch {
      // Storage may be unavailable in restricted browser modes.
    }
    setIsAuthenticated(false);
    setActiveTab('dashboard');
    setSearchTerm('');
    setMobileNavOpen(false);
  };

  const submitStudentForm = async () => {
    if (!studentForm.full_name || !studentForm.email) {
      alert('Name and email are required.');
      return;
    }
    try {
      await fetchJson('/api/students', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(studentForm),
      });
      setStudentForm({ full_name: '', email: '', phone: '', gender: '' });
      setShowStudentForm(false);
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const submitRoomForm = async () => {
    if (!roomForm.building_id || !roomForm.room_type_id || !roomForm.room_no) {
      alert('Building, room type, and room number are required.');
      return;
    }
    try {
      await fetchJson('/api/rooms', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...roomForm,
          building_id: Number(roomForm.building_id),
          room_type_id: Number(roomForm.room_type_id),
        }),
      });
      setRoomForm({ building_id: '', room_type_id: '', room_no: '', status: 'available' });
      setShowRoomForm(false);
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const submitPaymentForm = async () => {
    const { student_id, amount, period_start, period_end } = paymentForm;
    if (!student_id || !amount || !period_start || !period_end) {
      alert('Student, amount, and period dates are required.');
      return;
    }
    try {
      await fetchJson('/api/payments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...paymentForm,
          student_id: Number(paymentForm.student_id),
          amount: Number(paymentForm.amount),
        }),
      });
      setPaymentForm({ student_id: '', amount: '', period_start: '', period_end: '', method: 'cash', status: 'pending' });
      setShowPaymentForm(false);
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const submitMaintenanceForm = async () => {
    if (!maintenanceForm.room_id || !maintenanceForm.category) {
      alert('Room and category are required.');
      return;
    }
    try {
      await fetchJson('/api/maintenance', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...maintenanceForm,
          room_id: Number(maintenanceForm.room_id),
          student_id: maintenanceForm.student_id ? Number(maintenanceForm.student_id) : null,
        }),
      });
      setMaintenanceForm({ room_id: '', student_id: '', category: '', priority: 'medium', status: 'open', description: '' });
      setShowMaintenanceForm(false);
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const deleteStudent = async (id) => {
    if (!confirm('Delete this student?')) return;
    try {
      await fetchJson(`/api/students/${id}`, { method: 'DELETE' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const deleteRoom = async (id) => {
    if (!confirm('Delete this room?')) return;
    try {
      await fetchJson(`/api/rooms/${id}`, { method: 'DELETE' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const deletePayment = async (id) => {
    if (!confirm('Delete this payment?')) return;
    try {
      await fetchJson(`/api/payments/${id}`, { method: 'DELETE' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const deleteMaintenance = async (id) => {
    if (!confirm('Delete this request?')) return;
    try {
      await fetchJson(`/api/maintenance/${id}`, { method: 'DELETE' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const restoreStudent = async (id) => {
    try {
      await fetchJson(`/api/students/${id}/restore`, { method: 'POST' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const restoreRoom = async (id) => {
    try {
      await fetchJson(`/api/rooms/${id}/restore`, { method: 'POST' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const restorePayment = async (id) => {
    try {
      await fetchJson(`/api/payments/${id}/restore`, { method: 'POST' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const restoreMaintenance = async (id) => {
    try {
      await fetchJson(`/api/maintenance/${id}/restore`, { method: 'POST' });
      loadData();
    } catch (err) {
      alert(err.message);
    }
  };

  const isDark = theme === 'dark';
  const pageBg = isDark ? 'bg-slate-900 text-slate-100' : 'bg-slate-100 text-slate-900';
  const cardBg = isDark ? 'bg-slate-800 border border-slate-700' : 'bg-white border border-slate-200';
  const subtleBg = isDark ? 'bg-slate-800' : 'bg-slate-50';
  const inputBg = isDark
    ? 'bg-slate-800 border-slate-600 text-slate-100 placeholder:text-slate-400'
    : 'bg-white border-slate-300 text-slate-900 placeholder:text-slate-400';
  const navActive = isDark ? 'bg-blue-500' : 'bg-blue-600';
  const navHover = isDark ? 'hover:bg-slate-800' : 'hover:bg-slate-800';

  const StatCard = ({ icon: Icon, title, value, subtitle, color }) => (
    <div className={`${cardBg} rounded-lg shadow p-6 border-l-4`} style={{ borderLeftColor: color }}>
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-500 dark:text-gray-300">{title}</p>
          <p className="text-3xl font-bold mt-1">{value}</p>
          {subtitle && <p className="text-xs mt-1 text-gray-400 dark:text-gray-300">{subtitle}</p>}
        </div>
        {React.createElement(Icon, { className: 'text-gray-400', size: 40 })}
      </div>
    </div>
  );

  const Dashboard = () => (
    <div>
      <h2 className="text-2xl font-bold mb-6">Dashboard Overview</h2>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
        <StatCard icon={Users} title="Total Students" value={stats?.total_students ?? '-'} color="#3b82f6" />
        <StatCard icon={Building2} title="Total Rooms" value={stats?.total_rooms ?? '-'} subtitle={`${stats?.occupancy_rate ?? 0}% occupied`} color="#10b981" />
        <StatCard icon={DollarSign} title="Pending Payments" value={stats?.pending_payments ?? '-'} color="#f59e0b" />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className={`${cardBg} rounded-lg shadow p-6`}>
          <h3 className="font-bold text-lg mb-4">Recent Maintenance Requests</h3>
          {maintenance.slice(0, 3).map(req => (
            <div key={req.request_id} className={`flex items-start gap-3 p-3 rounded mb-2 ${subtleBg}`}>
              <AlertCircle className="text-red-500 mt-1" size={20} />
              <div className="flex-1">
                <p className="font-semibold">{req.building} - Room {req.room_no}</p>
                <p className="text-sm text-slate-700 dark:text-slate-200">{req.description}</p>
                <div className="flex gap-2 mt-2">
                  <span className={`text-xs px-2 py-1 rounded ${
                    req.priority === 'high' ? 'bg-red-100 text-red-800' :
                    req.priority === 'medium' ? 'bg-yellow-100 text-yellow-800' :
                    'bg-gray-100 text-gray-800'
                  }`}>{req.priority}</span>
                  <span className="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded">{req.status}</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className={`${cardBg} rounded-lg shadow p-6`}>
          <h3 className="font-bold text-lg mb-4">Pending Payments</h3>
          {payments.filter(p => p.status === 'pending').slice(0, 4).map(pay => (
            <div key={pay.payment_id} className={`flex items-center justify-between p-3 rounded mb-2 ${subtleBg}`}>
              <div>
                <p className="font-semibold">{pay.student}</p>
                <p className="text-sm text-gray-600">
                  {pay.period_start} to {pay.period_end}
                </p>
              </div>
              <div className="text-right">
                <p className="font-bold text-orange-600">{Number(pay.amount).toLocaleString()} KGS</p>
                <span className="text-xs bg-orange-100 text-orange-800 px-2 py-1 rounded">{pay.status}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  const Students = () => (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">Students</h2>
        <button onClick={() => setShowStudentForm(true)} className="bg-blue-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-blue-700">
          <Plus size={20} /> Add Student
        </button>
      </div>
      <div className={`${cardBg} rounded-lg shadow`}>
        <div className="overflow-x-auto">
          <table className="w-full min-w-[720px]">
            <thead className={subtleBg}>
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Phone</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Room</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700 text-sm">
              {students.map(student => (
                <tr key={student.student_id} className={`${isDark ? 'hover:bg-slate-800' : 'hover:bg-slate-100'}`}>
                  <td className="px-4 py-3">{student.full_name}</td>
                  <td className="px-4 py-3">{student.email}</td>
                  <td className="px-4 py-3">{student.phone}</td>
                  <td className="px-4 py-3">
                    {student.building ? `${student.building} - ${student.room_no}` : 'Unassigned'}
                  </td>
                  <td className="px-4 py-3">
                    <span className="bg-green-100 text-green-800 px-2 py-1 rounded text-xs">Active</span>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex justify-end">
                      <button onClick={() => deleteStudent(student.student_id)} className={deleteButtonClass}>
                        <Trash2 size={16} />
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );

  const Rooms = () => (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">Rooms</h2>
        <button onClick={() => setShowRoomForm(true)} className="bg-blue-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-blue-700">
          <Plus size={20} /> Add Room
        </button>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {rooms.map(room => (
          <div key={room.room_id} className={`${cardBg} rounded-lg shadow p-6 transition-shadow`}>
            <div className="flex justify-between items-start gap-4 mb-4">
              <div className="min-w-0">
                <h3 className="font-bold text-lg">{room.building}</h3>
                <p className="text-gray-600 dark:text-gray-300">Room {room.room_no}</p>
              </div>
              <div className="flex shrink-0 items-center gap-2">
                <span className={`px-2 py-1 rounded text-xs ${room.status === 'available' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                  {room.status}
                </span>
                <button onClick={() => deleteRoom(room.room_id)} className={compactDeleteButtonClass}>
                  <Trash2 size={14} />
                  Delete
                </button>
              </div>
            </div>
            <div className="space-y-2 mb-4">
              <p className="text-sm"><span className="font-semibold">Type:</span> {room.room_type}</p>
              <p className="text-sm"><span className="font-semibold">Occupancy:</span> {room.occupied}/{room.capacity}</p>
              <p className="text-sm"><span className="font-semibold">Rate:</span> {Number(room.monthly_rate).toLocaleString()} KGS/month</p>
            </div>
            <div className="flex flex-wrap gap-2">
              {(room.facilities || []).map(facility => (
                <span key={facility} className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">{facility}</span>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );


  const Payments = () => (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">Payments</h2>
        <button onClick={() => setShowPaymentForm(true)} className="bg-blue-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-blue-700">
          <Plus size={20} /> Record Payment
        </button>
      </div>
      <div className={`${cardBg} rounded-lg shadow`}>
        {/* Mobile card layout */}
        <div className="space-y-3 lg:hidden">
          {payments.map(payment => (
            <div key={payment.payment_id} className="border border-gray-200 rounded-lg p-4 pr-28 relative">
              <button onClick={() => deletePayment(payment.payment_id)} className={`${deleteButtonClass} absolute top-3 right-3`}>
                <Trash2 size={16} />
                Delete
              </button>
              <div className="font-semibold">{payment.student}</div>
              <div className="text-sm text-gray-600">{payment.period_start} to {payment.period_end}</div>
              <div className="flex flex-wrap items-center gap-2 text-sm mt-2">
                <span className="font-semibold">{Number(payment.amount).toLocaleString()} KGS</span>
                <span className="capitalize text-gray-700 dark:text-gray-200">{payment.method}</span>
                {payment.status === 'paid' ? (
                  <span className="bg-green-100 text-green-800 px-2 py-1 rounded text-xs flex items-center gap-1 w-fit">
                    <CheckCircle size={14} /> Paid
                  </span>
                ) : (
                  <span className="bg-orange-100 text-orange-800 px-2 py-1 rounded text-xs flex items-center gap-1 w-fit">
                    <Clock size={14} /> Pending
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* Desktop/tablet table */}
        <div className="hidden lg:block overflow-x-auto">
          <table className="w-full min-w-[900px]">
            <thead className={subtleBg}>
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Student</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Period</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Amount</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Method</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700 text-sm">
              {payments.map(payment => (
                <tr key={payment.payment_id} className={`${isDark ? 'hover:bg-slate-800' : 'hover:bg-slate-100'}`}>
                  <td className="px-4 py-3">{payment.student}</td>
                  <td className="px-4 py-3">{payment.period_start} to {payment.period_end}</td>
                  <td className="px-4 py-3 font-semibold">{Number(payment.amount).toLocaleString()} KGS</td>
                  <td className="px-4 py-3 text-gray-900 dark:text-white capitalize font-medium">{payment.method}</td>
                  <td className="px-4 py-3">
                    {payment.status === 'paid' ? (
                      <span className="bg-green-100 text-green-800 px-2 py-1 rounded text-xs flex items-center gap-1 w-fit">
                        <CheckCircle size={14} /> Paid
                      </span>
                    ) : (
                      <span className="bg-orange-100 text-orange-800 px-2 py-1 rounded text-xs flex items-center gap-1 w-fit">
                        <Clock size={14} /> Pending
                      </span>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex justify-end">
                      <button onClick={() => deletePayment(payment.payment_id)} className={deleteButtonClass}>
                        <Trash2 size={16} />
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );

  const Maintenance = () => (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold">Maintenance Requests</h2>
        <button onClick={() => setShowMaintenanceForm(true)} className="!bg-blue-600 !text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:!bg-blue-700">
          <Plus size={20} /> New Request
        </button>
      </div>
      <div className="space-y-4">
        {maintenance.map(req => (
          <div
            key={req.request_id}
            className={`${cardBg} rounded-lg shadow p-6`}
            style={{ color: isDark ? '#f8fafc' : '#0f172a' }}
          >
            <div className="flex justify-between gap-3 mb-4">
              <div>
                <h3 className="font-bold text-lg">{req.building} - Room {req.room_no}</h3>
                <p className="capitalize" style={{ color: isDark ? '#cbd5e1' : '#334155' }}>{req.category}</p>
              </div>
              <div className="flex flex-col items-end gap-2 sm:flex-row sm:items-center sm:gap-2">
                <div className="flex gap-2">
                  <span className={`px-2 py-1 rounded text-xs ${
                    req.priority === 'high' ? 'bg-red-100 text-red-800' :
                    req.priority === 'medium' ? 'bg-yellow-100 text-yellow-800' :
                    'bg-gray-100 text-gray-800'
                  }`}>
                    {req.priority}
                  </span>
                  <span className="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs capitalize">
                    {req.status.replace('_', ' ')}
                  </span>
                </div>
                <button onClick={() => deleteMaintenance(req.request_id)} className={maintenanceDeleteButtonClass}>
                  <Trash2 size={14} />
                  Delete
                </button>
              </div>
            </div>
            <p className="mb-2" style={{ color: isDark ? '#f1f5f9' : '#1e293b' }}>{req.description}</p>
            <p className="text-xs" style={{ color: isDark ? '#cbd5e1' : '#475569' }}>Created: {req.created_at?.split('T')[0]}</p>
          </div>
        ))}
      </div>
    </div>
  );

  const Recovery = () => (
    <div className="space-y-8">
      <h2 className="text-2xl font-bold">Recovery (last 30 days)</h2>

      <div>
        <h3 className="text-lg font-semibold mb-2">Students</h3>
        {deletedStudents.length === 0 ? (
          <p className="text-sm text-gray-500">No deleted students.</p>
        ) : (
          <div className={`${cardBg} rounded-lg shadow`}>
            <div className="overflow-x-auto">
              <table className="w-full min-w-[520px]">
                <thead className={subtleBg}>
                  <tr>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 dark:divide-gray-700 text-sm">
                  {deletedStudents.map(s => (
                    <tr key={s.student_id}>
                      <td className="px-4 py-2">{s.full_name}</td>
                      <td className="px-4 py-2 text-gray-600 dark:text-gray-300">{s.email}</td>
                      <td className="px-4 py-2">
                        <button onClick={() => restoreStudent(s.student_id)} className="px-3 py-1 rounded-full bg-green-50 text-green-700 border border-green-200 text-xs font-medium hover:bg-green-100">
                          Restore
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      <div>
        <h3 className="text-lg font-semibold mb-2">Rooms</h3>
        {deletedRooms.length === 0 ? (
          <p className="text-sm text-gray-500">No deleted rooms.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {deletedRooms.map(r => (
              <div key={r.room_id} className={`${cardBg} rounded-lg p-4 shadow`}>
                <div className="flex justify-between items-start mb-2">
                  <div>
                    <p className="font-semibold">{r.building} - {r.room_no}</p>
                    <p className="text-sm text-gray-600 dark:text-gray-300">{r.room_type}</p>
                  </div>
                  <button onClick={() => restoreRoom(r.room_id)} className="px-3 py-1 rounded-full bg-green-50 text-green-700 border border-green-200 text-xs font-medium hover:bg-green-100">
                    Restore
                  </button>
                </div>
                <p className="text-sm text-gray-600 dark:text-gray-300">Capacity: {r.capacity}, Rate: {Number(r.monthly_rate).toLocaleString()} KGS</p>
              </div>
            ))}
          </div>
        )}
      </div>

      <div>
        <h3 className="text-lg font-semibold mb-2">Payments</h3>
        {deletedPayments.length === 0 ? (
          <p className="text-sm text-gray-500">No deleted payments.</p>
        ) : (
          <div className={`${cardBg} rounded-lg shadow`}>
            <div className="overflow-x-auto">
              <table className="w-full min-w-[680px]">
                <thead className={subtleBg}>
                  <tr>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Student</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Period</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Amount</th>
                    <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 dark:divide-gray-700 text-sm">
                  {deletedPayments.map(p => (
                    <tr key={p.payment_id}>
                      <td className="px-4 py-2">{p.student}</td>
                      <td className="px-4 py-2 text-gray-600 dark:text-gray-300">{p.period_start} to {p.period_end}</td>
                      <td className="px-4 py-2 font-semibold">{Number(p.amount).toLocaleString()} KGS</td>
                      <td className="px-4 py-2">
                        <button onClick={() => restorePayment(p.payment_id)} className="px-3 py-1 rounded-full bg-green-50 text-green-700 border border-green-200 text-xs font-medium hover:bg-green-100">
                          Restore
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>

      <div>
        <h3 className="text-lg font-semibold mb-2">Maintenance</h3>
        {deletedMaintenance.length === 0 ? (
          <p className="text-sm text-gray-500">No deleted maintenance requests.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {deletedMaintenance.map(req => (
              <div key={req.request_id} className={`${cardBg} rounded-lg p-4 shadow`}>
                <div className="flex justify-between items-start mb-2">
                  <div>
                    <p className="font-semibold">{req.building} - Room {req.room_no}</p>
                    <p className="text-sm text-gray-600 dark:text-gray-300 capitalize">{req.category}</p>
                  </div>
                  <button onClick={() => restoreMaintenance(req.request_id)} className="px-3 py-1 rounded-full bg-green-50 text-green-700 border border-green-200 text-xs font-medium hover:bg-green-100">
                    Restore
                  </button>
                </div>
            <p className="text-sm text-black dark:text-gray-100 mb-1">{req.description}</p>
            <p className="text-xs text-black dark:text-gray-200">Created: {req.created_at?.split('T')[0]}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );

  const tabs = [
    { id: 'dashboard', name: 'Dashboard', icon: Home },
    { id: 'students', name: 'Students', icon: Users },
    { id: 'rooms', name: 'Rooms', icon: Building2 },
    { id: 'payments', name: 'Payments', icon: DollarSign },
    { id: 'maintenance', name: 'Maintenance', icon: Wrench },
    { id: 'recovery', name: 'Recovery', icon: Settings }
  ];

  if (!isAuthenticated) {
    return (
      <LoginScreen
        form={loginForm}
        error={loginError}
        onChange={setLoginForm}
        onSubmit={handleLogin}
      />
    );
  }

  return (
    <div className={`min-h-screen ${pageBg}`}>
      <div className="flex min-h-screen">
        {/* Sidebar */}
        <aside
          className={`fixed inset-y-0 left-0 z-40 w-64 bg-gray-900 text-white p-6 shadow-xl transform transition-transform duration-200 lg:translate-x-0 ${
            mobileNavOpen ? 'translate-x-0' : '-translate-x-full'
          } lg:static lg:block lg:shadow-none overflow-y-auto`}
        >
          <div className="mb-8">
            <h1 className="text-2xl font-bold">AUCA Dorm</h1>
            <p className="text-gray-400 text-sm">Management System</p>
          </div>
          <nav className="space-y-2">
            {tabs.map(tab => {
              const Icon = tab.icon;
              return (
                <button
                  key={tab.id}
                  onClick={() => {
                    setActiveTab(tab.id);
                    setMobileNavOpen(false);
                  }}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
                    activeTab === tab.id ? navActive : navHover
                  }`}
                >
                  <Icon size={20} />
                  <span>{tab.name}</span>
                </button>
              );
            })}
          </nav>
        </aside>

        {mobileNavOpen && (
          <div
            className="fixed inset-0 z-30 bg-black/50 lg:hidden"
            onClick={() => setMobileNavOpen(false)}
            aria-hidden="true"
          />
        )}

        {/* Main Content */}
        <div className="flex-1 flex flex-col min-h-screen">
          <header
            className={`sticky top-0 z-20 flex flex-wrap items-center gap-3 px-4 lg:px-6 py-4 border-b backdrop-blur ${
              isDark ? 'bg-slate-900/90 border-slate-700' : 'bg-slate-100/90 border-slate-200'
            }`}
          >
            <button
              className="lg:hidden p-2 rounded-lg hover:bg-slate-200 dark:hover:bg-slate-800 transition text-white"
              onClick={() => setMobileNavOpen(!mobileNavOpen)}
              aria-label="Toggle navigation"
            >
              <Menu size={20} />
            </button>
            <div className="relative flex-1 min-w-0">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
              <input
                type="text"
                placeholder="Search..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className={`w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 ${inputBg}`}
              />
            </div>
            <button
              onClick={() => setTheme(isDark ? 'light' : 'dark')}
              className="flex items-center gap-2 px-3 py-2 rounded-lg text-sm transition-colors shrink-0 border shadow-sm"
              style={{
                backgroundColor: isDark ? '#f8fafc' : '#171717',
                borderColor: isDark ? '#e2e8f0' : '#171717',
                color: isDark ? '#0f172a' : '#ffffff',
              }}
              aria-label="Toggle theme"
            >
              {isDark ? <Sun size={18} /> : <Moon size={18} />}
              <span className="text-sm hidden sm:inline">{isDark ? 'Light' : 'Dark'}</span>
            </button>
            <button
              onClick={handleLogout}
              className="flex items-center gap-2 px-3 py-2 rounded-lg text-sm transition-colors shrink-0
                !bg-red-600 !text-white hover:!bg-red-700
                dark:!bg-red-500 dark:!text-white dark:hover:!bg-red-600"
              aria-label="Logout"
            >
              <LogOut size={18} className="text-white" />
              <span className="text-sm hidden sm:inline text-white">Logout</span>
            </button>
          </header>

          <main className="flex-1 p-6 lg:p-8 space-y-6">
            {loading && <p className="text-gray-500">Loading...</p>}
            {error && <p className="text-red-600">Error: {error}</p>}

            {activeTab === 'dashboard' && <Dashboard />}
            {activeTab === 'students' && <Students />}
            {activeTab === 'rooms' && <Rooms />}
            {activeTab === 'payments' && <Payments />}
            {activeTab === 'maintenance' && <Maintenance />}
            {activeTab === 'recovery' && <Recovery />}
          </main>
        </div>
      </div>

      {showStudentForm && (
        <Modal title="Add Student" onClose={() => setShowStudentForm(false)} onSubmit={submitStudentForm} actionLabel="Add">
          <div className="grid grid-cols-1 gap-3">
            <div>
              <label className="block text-sm text-gray-600 mb-1">Full Name</label>
              <input className="w-full border rounded px-3 py-2" value={studentForm.full_name} onChange={(e) => setStudentForm({ ...studentForm, full_name: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Email</label>
              <input type="email" className="w-full border rounded px-3 py-2" value={studentForm.email} onChange={(e) => setStudentForm({ ...studentForm, email: e.target.value })} />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              <div>
                <label className="block text-sm text-gray-600 mb-1">Phone</label>
                <input className="w-full border rounded px-3 py-2" value={studentForm.phone} onChange={(e) => setStudentForm({ ...studentForm, phone: e.target.value })} />
              </div>
              <div>
                <label className="block text-sm text-gray-600 mb-1">Gender</label>
                <select className="w-full border rounded px-3 py-2" value={studentForm.gender} onChange={(e) => setStudentForm({ ...studentForm, gender: e.target.value })}>
                  <option value="">Select</option>
                  <option value="M">M</option>
                  <option value="F">F</option>
                </select>
              </div>
            </div>
          </div>
        </Modal>
      )}

      {showRoomForm && (
        <Modal title="Add Room" onClose={() => setShowRoomForm(false)} onSubmit={submitRoomForm} actionLabel="Add">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-sm text-gray-600 mb-1">Building ID</label>
              <input type="number" className="w-full border rounded px-3 py-2" value={roomForm.building_id} onChange={(e) => setRoomForm({ ...roomForm, building_id: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Room Type ID</label>
              <input type="number" className="w-full border rounded px-3 py-2" value={roomForm.room_type_id} onChange={(e) => setRoomForm({ ...roomForm, room_type_id: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Room Number</label>
              <input className="w-full border rounded px-3 py-2" value={roomForm.room_no} onChange={(e) => setRoomForm({ ...roomForm, room_no: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Status</label>
              <select className="w-full border rounded px-3 py-2" value={roomForm.status} onChange={(e) => setRoomForm({ ...roomForm, status: e.target.value })}>
                <option value="available">available</option>
                <option value="occupied">occupied</option>
                <option value="maintenance">maintenance</option>
              </select>
            </div>
          </div>
        </Modal>
      )}

      {showPaymentForm && (
        <Modal title="Record Payment" onClose={() => setShowPaymentForm(false)} onSubmit={submitPaymentForm} actionLabel="Save">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-sm text-gray-600 mb-1">Student ID</label>
              <input type="number" className="w-full border rounded px-3 py-2" value={paymentForm.student_id} onChange={(e) => setPaymentForm({ ...paymentForm, student_id: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Amount</label>
              <input type="number" className="w-full border rounded px-3 py-2" value={paymentForm.amount} onChange={(e) => setPaymentForm({ ...paymentForm, amount: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Period Start</label>
              <input type="date" className="w-full border rounded px-3 py-2" value={paymentForm.period_start} onChange={(e) => setPaymentForm({ ...paymentForm, period_start: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Period End</label>
              <input type="date" className="w-full border rounded px-3 py-2" value={paymentForm.period_end} onChange={(e) => setPaymentForm({ ...paymentForm, period_end: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Method</label>
              <select className="w-full border rounded px-3 py-2" value={paymentForm.method} onChange={(e) => setPaymentForm({ ...paymentForm, method: e.target.value })}>
                <option value="cash">cash</option>
                <option value="card">card</option>
                <option value="transfer">transfer</option>
              </select>
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Status</label>
              <select className="w-full border rounded px-3 py-2" value={paymentForm.status} onChange={(e) => setPaymentForm({ ...paymentForm, status: e.target.value })}>
                <option value="pending">pending</option>
                <option value="paid">paid</option>
              </select>
            </div>
          </div>
        </Modal>
      )}

      {showMaintenanceForm && (
        <Modal title="New Maintenance Request" onClose={() => setShowMaintenanceForm(false)} onSubmit={submitMaintenanceForm} actionLabel="Save">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label className="block text-sm text-gray-600 mb-1">Room ID</label>
              <input type="number" className="w-full border rounded px-3 py-2" value={maintenanceForm.room_id} onChange={(e) => setMaintenanceForm({ ...maintenanceForm, room_id: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Student ID (optional)</label>
              <input type="number" className="w-full border rounded px-3 py-2" value={maintenanceForm.student_id} onChange={(e) => setMaintenanceForm({ ...maintenanceForm, student_id: e.target.value })} />
            </div>
            <div className="sm:col-span-2">
              <label className="block text-sm text-gray-600 mb-1">Category</label>
              <input className="w-full border rounded px-3 py-2" value={maintenanceForm.category} onChange={(e) => setMaintenanceForm({ ...maintenanceForm, category: e.target.value })} />
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Priority</label>
              <select className="w-full border rounded px-3 py-2" value={maintenanceForm.priority} onChange={(e) => setMaintenanceForm({ ...maintenanceForm, priority: e.target.value })}>
                <option value="low">low</option>
                <option value="medium">medium</option>
                <option value="high">high</option>
              </select>
            </div>
            <div>
              <label className="block text-sm text-gray-600 mb-1">Status</label>
              <select className="w-full border rounded px-3 py-2" value={maintenanceForm.status} onChange={(e) => setMaintenanceForm({ ...maintenanceForm, status: e.target.value })}>
                <option value="open">open</option>
                <option value="in_progress">in_progress</option>
                <option value="resolved">resolved</option>
                <option value="cancelled">cancelled</option>
              </select>
            </div>
            <div className="sm:col-span-2">
              <label className="block text-sm text-gray-600 mb-1">Description</label>
              <textarea className="w-full border rounded px-3 py-2" rows="3" value={maintenanceForm.description} onChange={(e) => setMaintenanceForm({ ...maintenanceForm, description: e.target.value })} />
            </div>
          </div>
        </Modal>
      )}
    </div>
  );
};

export default DormManagementSystem;
