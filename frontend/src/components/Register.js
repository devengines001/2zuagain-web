import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

function Register() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const navigate = useNavigate();

    const handleRegister = async () => {
        try {
            const res = await axios.post(`${process.env.REACT_APP_API_URL}/auth/register`, { email, password });
            alert(res.data.message);
            navigate('/');
        } catch (err) {
            alert(err.response.data.error);
        }
    };

    return (
        <div>
            <h1>Register</h1>
            <input placeholder="Email" value={email} onChange={e => setEmail(e.target.value)} />
            <input placeholder="Password" type="password" value={password} onChange={e => setPassword(e.target.value)} />
            <button onClick={handleRegister}>Register</button>
        </div>
    );
}

export default Register;
