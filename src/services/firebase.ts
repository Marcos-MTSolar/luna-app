import { initializeApp } from "firebase/app";
import { getFirestore, doc, getDoc, setDoc, updateDoc, arrayUnion } from "firebase/firestore";

const firebaseConfig = {
  // Substitua pelos valores do seu projeto Firebase
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
