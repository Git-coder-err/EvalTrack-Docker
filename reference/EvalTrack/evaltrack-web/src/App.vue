<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

const apiOk = ref(null);
const message = ref('Loading…');

axios.defaults.withCredentials = false;
axios.defaults.headers.common['Accept'] = 'application/json';

async function ping() {
  try {
    await axios.get('/api/auth/me', {
      validateStatus: (s) => s === 401 || s === 200,
    });
    apiOk.value = true;
    message.value = 'API reachable (port 5001 via Vite proxy). Log in to get a token.';
  } catch {
    apiOk.value = false;
    message.value = 'Cannot reach API. Is Laravel running on port 5001?';
  }
}

onMounted(ping);
</script>

<template>
  <div class="wrap">
    <h1>EvalTrack</h1>
    <p class="ports">Frontend <strong>:3002</strong> · API proxy → <strong>:5001</strong></p>
    <p :class="apiOk === true ? 'ok' : apiOk === false ? 'bad' : ''">{{ message }}</p>
  </div>
</template>
