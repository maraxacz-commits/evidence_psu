import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'https://pes.maraxa.cz/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Interceptor pro přidání tokenu do každého requestu
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor pro handling 401 (Unauthenticated)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token vypršel nebo je neplatný
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export interface RegisterData {
  username: string;
  email: string;
  password: string;
  password_confirmation: string;
  first_name?: string;
  last_name?: string;
  phone?: string;
  city?: string;
}

export interface LoginData {
  login: string;
  password: string;
}

export interface User {
  id: number;
  username: string;
  email: string;
  first_name?: string;
  last_name?: string;
  full_name: string;
  phone?: string;
  address?: string;
  city?: string;
  zip_code?: string;
  country?: string;
  is_active: boolean;
  created_at: string;
}

export interface AuthResponse {
  message: string;
  user: User;
  token: string;
}

// Auth API calls
export const authAPI = {
  register: async (data: RegisterData): Promise<AuthResponse> => {
    const response = await api.post<AuthResponse>('/register', data);
    return response.data;
  },

  login: async (data: LoginData): Promise<AuthResponse> => {
    const response = await api.post<AuthResponse>('/login', data);
    return response.data;
  },

  logout: async (): Promise<void> => {
    await api.post('/logout');
  },

  getUser: async (): Promise<User> => {
    const response = await api.get<{ user: User }>('/user');
    return response.data.user;
  },

  updateProfile: async (data: Partial<User>): Promise<User> => {
    const response = await api.put<{ user: User }>('/user', data);
    return response.data.user;
  },
};

export default api;
