import { initializeApp } from "firebase/app";
import { getFirestore, doc, getDoc, setDoc, updateDoc, arrayUnion } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyDYwAbIbbOwkSu9WyXu6mS7uhPNn3Nbe8M",
  authDomain: "luna-app-dd08b.firebaseapp.com",
  projectId: "luna-app-dd08b",
  storageBucket: "luna-app-dd08b.firebasestorage.app",
  messagingSenderId: "735293551960",
  appId: "1:735293551960:web:5df32299bcb8716928612d"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);

export async function carregarMemoria() {
  const ref = doc(db, "memoria", "luna");
  const snap = await getDoc(ref);
  return snap.exists() ? snap.data() : null;
}

export async function atualizarEstadoEmocional(estado: {
  humor: string;
  afeto: string;
  energia: string;
  sincronia: string;
}) {
  const ref = doc(db, "memoria", "luna");
  await updateDoc(ref, { estado_emocional: estado });
}

export async function registrarSessao(estado: {
  humor: string;
  afeto: string;
  energia: string;
  sincronia: string;
}) {
  const ref = doc(db, "memoria", "luna");
  await updateDoc(ref, {
    historico_emocional: arrayUnion({
      ...estado,
      timestamp: new Date().toISOString()
    })
  });
}
