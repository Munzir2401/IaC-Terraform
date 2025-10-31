import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 50 },
    { duration: '4m', target: 200 },   // sustain for autoscaling detection
    { duration: '4m', target: 400 },   // push harder if needed
    { duration: '2m', target: 0 },
  ],
  thresholds: { // optional
    http_req_failed: ['rate<0.01'],
  },
};

const BASE = 'http://prod-my-alb-1214647625.ap-south-1.elb.amazonaws.com';
const endpoints = ['/', '/cars', '/bikes', '/trucks', '/cpu-test'];

export default function () {
  // round-robin-ish: favor cpu-test to ensure CPU load
  const r = Math.random();
  let url = (r < 0.6) ? `${BASE}/cpu-test` : `${BASE}${endpoints[Math.floor(Math.random() * endpoints.length)]}`;
  http.get(url);
  sleep(0.1);
}