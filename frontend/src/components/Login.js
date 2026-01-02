import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function Login() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const navigate = useNavigate();

    const handleLogin = async () => {
        try {
            const res = await axios.post(`${process.env.REACT_APP_API_URL}/auth/login`, { email, password });
            alert(res.data.message);
            navigate('/main');
        } catch (err) {
            alert(err.response.data.error);
        }
    };

    return (
        <div>
            <h1>Login</h1>
            <input placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} />
            <input placeholder="Password" type="password" value={password} onChange={e => setPassword(e.target.value)} />
            <button onClick={handleLogin}>Login</button>
            <p>Don't have an account? <a href="/register">Register</a></p>
        </div>
    );
}

export default Login;
