import http from 'k6/http';
import { sleep } from 'k6';

export let options = {
  vus: 50,       // Number of virtual users
  duration: '30s', // Duration of the load test
};

export default function () {
  http.get('https://testwebsite.com');
  sleep(1);
}
